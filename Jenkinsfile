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
  try {

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

      /* Clean Silver-generated files from previous builds in this workspace */
      sh "rm -rf generated/* || true"

      /* a node allocates an executor to actually do work */
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

      // Checkout ableC
      try {
        checkout([ $class: 'GitSCM',
                   branches: scm.branches,
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'ableC'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC.git']
                   ]
                 ])
      }
      catch (e) {
        checkout([ $class: 'GitSCM',
                   branches: [[name: '*/develop']],
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'ableC'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC.git']
                   ]
                 ])
      }

      // Checkout dependanices
      try {
        checkout([ $class: 'GitSCM',
                   branches: scm.branches,
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'extensions/ableC-regex-lib'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC-regex-lib.git']
                   ]
                 ])
      }
      catch (e) {
        checkout([ $class: 'GitSCM',
                   branches: [[name: '*/develop']],
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'extensions/ableC-regex-lib'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC-regex-lib.git']
                   ]
                 ])
      }
      try {
        checkout([ $class: 'GitSCM',
                   branches: scm.branches,
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'extensions/ableC-regex-pattern-matching'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC-regex-pattern-matching.git']
                   ]
                 ])
      }
      catch (e) {
        checkout([ $class: 'GitSCM',
                   branches: [[name: '*/develop']],
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'extensions/ableC-regex-pattern-matching'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC-regex-pattern-matching.git']
                   ]
                 ])
      }
      try {
        checkout([ $class: 'GitSCM',
                   branches: scm.branches,
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'extensions/ableC-cilk'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC-cilk.git']
                   ]
                 ])
      }
      catch (e) {
        checkout([ $class: 'GitSCM',
                   branches: [[name: '*/develop']],
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'extensions/ableC-cilk'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC-cilk.git']
                   ]
                 ])
      }
      try {
        checkout([ $class: 'GitSCM',
                   branches: scm.branches,
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'extensions/ableC-sqlite'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC-sqlite.git']
                   ]
                 ])
      }
      catch (e) {
        checkout([ $class: 'GitSCM',
                   branches: [[name: '*/develop']],
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'extensions/ableC-sqlite'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC-sqlite.git']
                   ]
                 ])
      }
      try {
        checkout([ $class: 'GitSCM',
                   branches: scm.branches,
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'extensions/ableC-condition-tables'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC-condition-tables.git']
                   ]
                 ])
      }
      catch (e) {
        checkout([ $class: 'GitSCM',
                   branches: [[name: '*/develop']],
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'extensions/ableC-condition-tables'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC-condition-tables.git']
                   ]
                 ])
      }
      try {
        checkout([ $class: 'GitSCM',
                   branches: scm.branches,
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'extensions/ableC-algebraic-data-types'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC-algebraic-data-types.git']
                   ]
                 ])
      }
      catch (e) {
        checkout([ $class: 'GitSCM',
                   branches: [[name: '*/develop']],
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [
                     [ $class: 'RelativeTargetDirectory',
                       relativeTargetDir: 'extensions/ableC-algebraic-data-types'],
                     [ $class: 'CleanCheckout']
                   ],
                   userRemoteConfigs: [
                     [url: 'https://github.com/melt-umn/ableC-algebraic-data-types.git']
                   ]
                 ])
      }

      sh "mkdir -p generated"
    }

    stage ("Test") {
      withEnv(env) {
        dir("ableC_sample_projects") {
          sh "make clean all"
        }
      }
    }
  }
  catch (e) {
    currentBuild.result = 'FAILURE'
    throw e
  }
  finally {
    def previousResult = currentBuild.previousBuild?.result

    if (currentBuild.result == 'FAILURE') {
      notifyBuild(currentBuild.result)
    }
    else if (currentBuild.result == null &&
             previousResult && previousResult == 'FAILURE') {
      notifyBuild('BACK_TO_NORMAL')
    }
  }
}

/* Slack / email notification
 * notifyBuild() author: fahl-design
 * https://bitbucket.org/snippets/fahl-design/koxKe */
def notifyBuild(String buildStatus = 'STARTED') {
  // build status of null means successful
  buildStatus =  buildStatus ?: 'SUCCESSFUL'

  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = "${subject} (${env.BUILD_URL})"
  def details = """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
    <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>"""

  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    color = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESSFUL' || buildStatus == 'BACK_TO_NORMAL') {
    color = 'GREEN'
    colorCode = '#00FF00'
  } else {
    color = 'RED'
    colorCode = '#FF0000'
  }

  // Send notifications
  slackSend (color: colorCode, message: summary)

  emailext(
    subject: subject,
    body: details,
    to: 'evw@umn.edu',
    recipientProviders: [[$class: 'CulpritsRecipientProvider']]
  )
}
