#!groovy

library "github.com/melt-umn/jenkins-lib"

// This isn't a real extension, so we use a semi-custom approach

melt.setProperties(silverBase: true, ablecBase: true, silverAblecBase: true)

def extension_name = 'ableC-sample-projects'
def extensions = ['ableC-regex-lib', 'ableC-regex-pattern-matching', 'ableC-cilk', 'ableC-sqlite', 'ableC-condition-tables', 'ableC-algebraic-data-types', 'ableC-string']

node {
try {

  def newenv

  stage ("Checkout") {
    // We'll check it out underneath extensions/ just so we can re-use this code
    // It shouldn't hurt because newenv should specify where extensions and ablec_base can be found
    newenv = ablec.prepareWorkspace(extension_name, extensions, true)
  }

  stage ("Test") {
    withEnv(newenv) {
      dir("extensions/ableC-sample-projects") {
        sh "make clean all"
      }
    }
  }

  /* If we've gotten all this way with a successful build, don't take up disk space */
  sh "rm -rf generated/* || true"
}
catch (e) {
  melt.handle(e)
}
finally {
  melt.notify(job: extension_name)
}
} // node

