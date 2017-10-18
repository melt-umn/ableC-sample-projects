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
      ],
      [ $class: 'StringParameterDefinition',
        name: 'ABLEC_BASE',
        defaultValue: "ableC",
        description: 'AbleC installation path to use.'
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

      checkout scm

      sh "rm -rf generated/* || true"

        checkout([ $class: 'GitSCM',
               branches: [[name: '*/develop']],
               doGenerateSubmoduleConfigurations: false,
               extensions: [
                 [ $class: 'RelativeTargetDirectory',
                   relativeTargetDir: 'ableC'],
                 [ $class: 'CleanCheckout']
               ],
               submoduleCfg: [],
               userRemoteConfigs: [
                 [url: 'https://github.com/melt-umn/ableC.git']
               ]
             ])
        checkout([ $class: 'GitSCM',
               branches: [[name: '*/develop']],
               doGenerateSubmoduleConfigurations: false,
               extensions: [
                 [ $class: 'RelativeTargetDirectory',
                   relativeTargetDir: "extensions/ableC-regex-lib"]
               ],
               submoduleCfg: [],
               userRemoteConfigs: [
                 [url: 'https://github.com/melt-umn/ableC-regex-lib.git']
               ]
             ])
        checkout([ $class: 'GitSCM',
               branches: [[name: '*/develop']],
               doGenerateSubmoduleConfigurations: false,
               extensions: [
                 [ $class: 'RelativeTargetDirectory',
                   relativeTargetDir: "extensions/ableC-condition-tables"]
               ],
               submoduleCfg: [],
               userRemoteConfigs: [
                 [url: 'https://github.com/melt-umn/ableC-condition-tables.git']
               ]
             ])
    }
  stage ("Test") {
    node {
      withEnv(["PATH=${params.SILVER_BASE}/support/bin/:${env.PATH}"]) {
        dir("ableC_sample_projects") {
          sh "make clean all"
        }
      }
    }
  }
}

