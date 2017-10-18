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

stage ("Checkout") {

  /* a node allocates an executor to actually do work */
  node {
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
               doGenerateSubmoduleConfigurations: false,
               extensions: [
                 [ $class: 'RelativeTargetDirectory',
                   relativeTargetDir: 'ableC_sample_projects']
               ],
               submoduleCfg: [],
               userRemoteConfigs: [
                 [url: 'https://github.com/melt-umn/ableC_sample_projects']
               ]
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
}

stage ("Test") {
  node {
    withEnv(["PATH=${SILVER_BASE}/support/bin/:${env.PATH}"]) {
      sh "cd ableC_sample_projects && make clean all"
    }
  }
}
