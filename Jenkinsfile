#!groovy

/* Set the properties this job has.
   I think there's a bug where the very first run lacks these... */
properties([
  /* Set our config to take a parameter when a build is triggered.
     We should always have defaults, I don't know what happens when
     it's triggered by a commit without a default... */
  [ $class: 'ParametersDefinitionProperty',
    parameterDefinitions: [
      [ $class: 'StringParameterDefinition',
        name: 'SILVER_BASE',
        defaultValue: '/export/scratch/melt-jenkins/custom-silver/',
        description: 'Silver installation path to use. Currently assumes only one build machine. Otherwise a path is not sufficient, we need to copy artifacts or something else.'
      ]
    ]
  ],
  /* If we don't set this, everything is preserved forever.
     We don't bother discarding build logs (because they're small),
     but if this job keeps artifacts, we ask them to only stick around
     for awhile. */
  [ $class: 'BuildDiscarderProperty',
    strategy:
      [ $class: 'LogRotator',
        artifactDaysToKeepStr: '120',
        artifactNumToKeepStr: '20'
      ]
  ]
])

/* If the above syntax confuses you, be sure you've skimmed through
   https://github.com/jenkinsci/pipeline-plugin/blob/master/TUTORIAL.md

   In particular, Jenkins has this thing that turns a map with a '$class' property
   into an actual object of that type, with the remainder of the map being its
   parameters. */


/* stages are pretty much just labels about what's going on */

node {

  /* the full path to ableC, use parameter as-is if changed from default,
     * otherwise prepend full path to workspace */
  def ablec_base = (params.ABLEC_BASE == 'ableC') ? "${WORKSPACE}/${params.ABLEC_BASE}" : params.ABLEC_BASE
  def env = [
    "PATH=${params.SILVER_BASE}/support/bin/:${env.PATH}",
    "C_INCLUDE_PATH=/project/melt/Software/ext-libs/usr/local/include:${env.C_INCLUDE_PATH}",
    "LIBRARY_PATH=/project/melt/Software/ext-libs/usr/local/lib:${env.LIBRARY_PATH}",
    "ABLEC_BASE=${ablec_base}",
    "EXTS_BASE=${WORKSPACE}/extensions",
    "SVFLAGS=-G ${WORKSPACE}/generated"
  ]

  stage ("Build") {

    sh "mkdir -p generated"
    sh "rm -rf generated/* || true"
  
    checkout([ $class: 'GitSCM',
               branches: [[name: '*/develop']],
               doGenerateSubmoduleConfigurations: false,
               extensions: [
                 [ $class: 'RelativeTargetDirectory',
                   relativeTargetDir: 'ableC']
               ],
               submoduleCfg: [],
               userRemoteConfigs: [
                 [url: 'https://github.com/melt-umn/ableC.git']
               ]
             ])
    checkout([ $class: 'GitSCM',
               branches: scm.branches,
               doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
               extensions: [
                 [ $class: 'RelativeTargetDirectory',
                   relativeTargetDir: 'ableC_sample_projects'],
                   [ $class: 'CleanCheckout']
               ],
               submoduleCfg: scm.submoduleCfg,
               userRemoteConfigs: scm.userRemoteConfigs
             ])
    checkout([ $class: 'GitSCM',
              branches: [[name: '*/master']],
              extensions: [
                [ $class: 'RelativeTargetDirectory',
                  relativeTargetDir: "extensions/ableC-regex-lib"],
                  [ $class: 'CleanCheckout']
              ],
              userRemoteConfigs: [
                [url: 'https://github.com/melt-umn/ableC-regex-lib.git']
              ]
            ])
    checkout([ $class: 'GitSCM',
              branches: [[name: '*/master']],
              extensions: [
                [ $class: 'RelativeTargetDirectory',
                  relativeTargetDir: "extensions/ableC-regex-pattern-matching"],
                  [ $class: 'CleanCheckout']
              ],
              userRemoteConfigs: [
                [url: 'https://github.com/melt-umn/ableC-regex-pattern-matching.git']
              ]
            ])
    checkout([ $class: 'GitSCM',
              branches: [[name: '*/develop']],
              extensions: [
                [ $class: 'RelativeTargetDirectory',
                  relativeTargetDir: "extensions/ableC-cilk"],
                  [ $class: 'CleanCheckout']
              ],
              userRemoteConfigs: [
                [url: 'https://github.com/melt-umn/ableC-cilk.git']
              ]
            ])
    checkout([ $class: 'GitSCM',
              branches: [[name: '*/develop']],
              extensions: [
                [ $class: 'RelativeTargetDirectory',
                  relativeTargetDir: "extensions/ableC-sqlite"],
                  [ $class: 'CleanCheckout']
              ],
              submoduleCfg: [],
              userRemoteConfigs: [
                [url: 'https://github.com/melt-umn/ableC-sqlite.git']
              ]
            ])
      checkout([ $class: 'GitSCM',
              branches: [[name: '*/develop']],
              extensions: [
                [ $class: 'RelativeTargetDirectory',
                  relativeTargetDir: "extensions/ableC-condition-tables"],
                  [ $class: 'CleanCheckout']
              ],
              userRemoteConfigs: [
                [url: 'https://github.com/melt-umn/ableC-condition-tables.git']
              ]
            ])
      checkout([ $class: 'GitSCM',
              branches: [[name: '*/develop']],
              extensions: [
                [ $class: 'RelativeTargetDirectory',
                  relativeTargetDir: "extensions/ableC-algebraic-data-types"],
                  [ $class: 'CleanCheckout']
              ],
              userRemoteConfigs: [
                [url: 'https://github.com/melt-umn/ableC-algebraic-data-types.git']
              ]
            ])
  }
  stage ("Test") {
    node {
      withEnv(env) {
        sh "cd ableC_sample_projects && make clean all"
      }
    }
  }
}
