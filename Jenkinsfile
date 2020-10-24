#!groovy

library "github.com/melt-umn/jenkins-lib"

// This isn't a real extension, so we use a semi-custom approach

melt.setProperties(silverBase: true, ablecBase: true, silverAblecBase: true)

def extension_name = 'ableC-sample-projects'
def extensions = ['ableC-regex-lib', 'ableC-regex-pattern-matching', 'ableC-cilk', 'ableC-sqlite', 'ableC-condition-tables', 'ableC-algebraic-data-types', 'ableC-string', 'ableC-tensor-algebra', 'ableC-check', 'ableC-checkTaggedUnion', 'ableC-watch', 'ableC-nonnull', 'ableC-halide']

melt.trynode(extension_name) {
  def newenv

  stage ("Checkout") {
    melt.clearGenerated()
    
    // We'll check it out underneath extensions/ just so we can re-use this code
    // It shouldn't hurt because newenv should specify where extensions and ablec_base can be found
    newenv = ablec.prepareWorkspace(extension_name, extensions, true)
  }
  
  stage ("Test") {
    def examples = ['down_on_the_farm', 'parallel_tree_search', 'taco_string', 'type_qualifiers', 'using_scoped_keywords', 'using_transparent_prefixes']
    
    def tasks = [:]
    tasks << examples.collectEntries { t -> [(t): task_example(t, newenv)] }
    
    parallel tasks
  }

  /* If we've gotten all this way with a successful build, don't take up disk space */
  melt.clearGenerated()
}

// Build a specific example in the local workspace
def task_example(String examplepath, newenv) {
  def exts_base = env.WORKSPACE
  
  return {
    // Each parallel task executes in a seperate node
    node {
      melt.clearGenerated()

      // Override the env to use the task node's workspace for generated
      newenv << "SILVER_GEN=${env.WORKSPACE}/generated"
      
      withEnv(newenv) {
        // Go back to our "parent" workspace, into the example
        dir("${exts_base}/extensions/ableC-sample-projects/${examplepath}") {
          sh "make -j"
        }
      }
      // Blow away these generated files in our private workspace
      deleteDir()
    }
  }
}

