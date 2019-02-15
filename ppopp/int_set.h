#ifndef _INTSET_H
#define _INTSET_H

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct _IntSetNode {
    struct _IntSetNode *left;
    struct _IntSetNode *right;
    bool exists;
} _IntSetNode;

_IntSetNode *new_intsetnode(void)
{
    _IntSetNode *self = malloc(sizeof(_IntSetNode));
    self->left = NULL;
    self->right = NULL;
    self->exists = false;
    return self;
}

_IntSetNode *delete_intsetnode(_IntSetNode *self)
{
    if (self->left) {
        delete_intsetnode(self->left);
    }
    if (self->right) {
        delete_intsetnode(self->right);
    }
    free(self);
}

_IntSetNode *dup_intsetnode(const _IntSetNode *other)
{
    _IntSetNode *self = malloc(sizeof(_IntSetNode));
    self->left = other->left ? dup_intsetnode(other->left) : NULL;
    self->right = other->right ? dup_intsetnode(other->right) : NULL;
    self->exists = other->exists;
    return self;
}

bool intsetnode_member(const _IntSetNode *self, int x_plus1)
{
    bool ret;
    if (x_plus1 == 1) {
        ret = self->exists;
    } else if ((x_plus1 & 1) == 0) {
        ret = self->left && intsetnode_member(self->left, x_plus1 >> 1);
    } else {
        ret = self->right && intsetnode_member(self->right, x_plus1 >> 1);
    }
    return ret;
}

void intsetnode_insert(_IntSetNode *self, int x_plus1)
{
    if (x_plus1 == 1) {
        self->exists = true;
    } else if ((x_plus1 & 1) == 0) {
        if (!self->left) {
            self->left = new_intsetnode();
	}
	intsetnode_insert(self->left, x_plus1 >> 1);
    } else {
        if (!self->right) {
            self->right = new_intsetnode();
	}
	intsetnode_insert(self->right, x_plus1 >> 1);
    }
}

void intsetnode_remove(_IntSetNode *self, int x_plus1)
{
    if (x_plus1 == 1) {
        self->exists = false;
    } else if ((x_plus1 & 1) == 0) {
        if (self->left) {
	    intsetnode_remove(self->left, x_plus1 >> 1);
        }
    } else {
        if (self->right) {
	    intsetnode_remove(self->right, x_plus1 >> 1);
        }
    }
}

void intsetnode_union(_IntSetNode *self, const _IntSetNode *n2)
{
    self->exists = self->exists || n2->exists;
    if (n2->left) {
        if (!self->left) {
            self->left = dup_intsetnode(n2->left);
        } else {
            intsetnode_union(self->left, n2->left);
	}
    }
    if (n2->right) {
        if (!self->right) {
            self->right = dup_intsetnode(n2->right);
        } else {
            intsetnode_union(self->right, n2->right);
	}
    }
}

void intsetnode_minus(_IntSetNode *self, const _IntSetNode *n2)
{
    self->exists = self->exists && !n2->exists;
    if (n2->left && self->left) {
        intsetnode_minus(self->left, n2->left);
    }
    if (n2->right && self->right) {
        intsetnode_minus(self->right, n2->right);
    }
}

bool intsetnode_is_empty(const _IntSetNode *self)
{
    return !self->exists && (!self->left || intsetnode_is_empty(self->left))
                && (!self->right || intsetnode_is_empty(self->right));
}

typedef struct {
    _IntSetNode *root;
    /** special case for -1 because inserting it won't terminate */
    bool negative_one_exists;
} IntSet;

IntSet *new_intset(void)
{
    IntSet *self = malloc(sizeof(IntSet));
    self->root = new_intsetnode();
    self->negative_one_exists = false;

    return self;
}

void delete_intset(IntSet *self)
{
    delete_intsetnode(self->root);
    free(self);
}

bool intset_member(const IntSet *self, int x)
{
    return intsetnode_member(self->root, x+1);
}

void intset_insert(IntSet *self, int x)
{
    if (x == -1) {
        self->negative_one_exists = true;
    } else {
        intsetnode_insert(self->root, x+1);
    }
}

void intset_remove(IntSet *self, int x)
{
    if (x == -1) {
        self->negative_one_exists = false;
    } else {
        intsetnode_remove(self->root, x+1);
    }
}

void intset_union(IntSet *self, const IntSet *s2)
{
    self->negative_one_exists = self->negative_one_exists || s2->negative_one_exists;
    intsetnode_union(self->root, s2->root);
}

void intset_minus(IntSet *self, const IntSet *s2)
{
    self->negative_one_exists = self->negative_one_exists && !s2->negative_one_exists;
    intsetnode_minus(self->root, s2->root);
}

bool intset_is_empty(const IntSet *self)
{
    return !self->negative_one_exists && intsetnode_is_empty(self->root);
}

// to copy the values in an IntSet
IntSet* copyIntSet(IntSet* set) {
  IntSet* copy = malloc(sizeof(IntSet));
  copy -> root = dup_intsetnode(set->root);
  copy -> negative_one_exists = set->negative_one_exists;
  return copy;
}

typedef enum {
    INIT, CUR, LEFT, RIGHT, END
} NodePos;

typedef struct _IntSetNodeItr {
    const _IntSetNode *n;
    struct _IntSetNodeItr *left_itr;
    struct _IntSetNodeItr *right_itr;
    NodePos pos;
} _IntSetNodeItr;

bool intsetnodeitr_has_next(const _IntSetNodeItr *self)
{
    bool ret;

    switch (self->pos) {
    case INIT:
        ret = self->n->exists || (self->left_itr && intsetnodeitr_has_next(self->left_itr))
                || (self->right_itr && intsetnodeitr_has_next(self->right_itr));
        break;
    case CUR: /* pass through */
    case LEFT:
        ret = (self->left_itr && intsetnodeitr_has_next(self->left_itr))
                || (self->right_itr && intsetnodeitr_has_next(self->right_itr));
        break;
    case RIGHT:
        ret = self->right_itr && intsetnodeitr_has_next(self->right_itr);
        break;
    case END:
        ret = false;
        break;
    }

    return ret;
}

void intsetnodeitr_move_next(_IntSetNodeItr *self)
{
    switch (self->pos) {
    case INIT:
        self->pos = CUR;
        if (!self->n->exists) {
            intsetnodeitr_move_next(self);
        }
        break;
    case CUR:
        self->pos = LEFT;
        intsetnodeitr_move_next(self);
        break;
    case LEFT:
        if (self->left_itr && intsetnodeitr_has_next(self->left_itr)) {
            intsetnodeitr_move_next(self->left_itr);
        } else {
            self->pos = RIGHT;
            intsetnodeitr_move_next(self);
        }
        break;
    case RIGHT:
        if (self->right_itr && intsetnodeitr_has_next(self->right_itr)) {
            intsetnodeitr_move_next(self->right_itr);
        } else {
            self->pos = END;
        }
        break;
    case END:
        break;
    }
}

int intsetnodeitr_value(const _IntSetNodeItr *self, size_t depth)
{
    int ret;
    switch (self->pos) {
    case INIT:
        fprintf(stderr, "ERROR: intsetnodeitr_value() called when uninitialized\n");
        exit(255);
        break;
    case CUR:
        ret = 1 << depth;
        break;
    case LEFT:
        ret = intsetnodeitr_value(self->left_itr, depth+1);
        break;
    case RIGHT:
        ret = (1 << depth) | intsetnodeitr_value(self->right_itr, depth+1);
        break;
    case END:
        fprintf(stderr, "ERROR: intsetnodeitr_value() called when end of iterator reached\n");
        exit(255);
        break;
    }
    return ret;
}

_IntSetNodeItr *new_intsetnodeitr(const _IntSetNode *n)
{
    _IntSetNodeItr *self = malloc(sizeof(_IntSetNodeItr));
    self->n = n;
    self->pos = INIT;
    /* replicate entire tree for iteration, yikes */
    self->left_itr = n->left ? new_intsetnodeitr(n->left) : NULL;
    self->right_itr = n->right ? new_intsetnodeitr(n->right) : NULL;
    return self;
}

void delete_intsetnodeitr(_IntSetNodeItr *self)
{
    if (self->right_itr) {
        delete_intsetnodeitr(self->right_itr);
    }
    if (self->left_itr) {
        delete_intsetnodeitr(self->left_itr);
    }
    free(self);
}

typedef struct {
    const IntSet *s;
    _IntSetNodeItr *nitr;
    bool past_negative_one;
} IntSetItr;

IntSetItr *new_intsetitr(const IntSet *s)
{
    IntSetItr *self = malloc(sizeof(IntSetItr));
    self->s = s;
    self->nitr = new_intsetnodeitr(s->root);
    self->past_negative_one = false;
    return self;
}

void delete_intsetitr(IntSetItr *self)
{
    delete_intsetnodeitr(self->nitr);
    free(self);
}

bool intsetitr_has_next(const IntSetItr *self)
{
    return (!self->past_negative_one && self->s->negative_one_exists)
        || intsetnodeitr_has_next(self->nitr);
}

int intsetitr_next(IntSetItr *self)
{
    int ret;

    if (!self->past_negative_one && self->s->negative_one_exists) {
        ret = -1;
        self->past_negative_one = true;
    } else {
        intsetnodeitr_move_next(self->nitr);
        ret = intsetnodeitr_value(self->nitr, 0) - 1;
    }

    return ret;
}

#endif

