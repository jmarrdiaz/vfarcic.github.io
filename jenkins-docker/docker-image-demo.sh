export DOCKER_HUB_USER=[...]

open "http://$CLUSTER_DNS/jenkins/credentials/store/system/domain/_/newCredentials"

# Add `docker`

open "http://$CLUSTER_DNS/jenkins/view/all/newJob"

echo 'import java.text.SimpleDateFormat

pipeline {
  agent {
    label "test"
  }
  options {
    buildDiscarder(logRotator(numToKeepStr: "2"))
    disableConcurrentBuilds()
  }
  environment {
    DOCKER_HUB_USER = [...]
  }
  stages {
    stage("build") {
      steps {
        git "https://github.com/vfarcic/go-demo-2.git"
        sh "docker image build -t ${env.DOCKER_HUB_USER}/go-demo-2:beta-${env.BUILD_NUMBER} ."
        withCredentials([usernamePassword(
          credentialsId: "docker",
          usernameVariable: "USER",
          passwordVariable: "PASS"
        )]) {
          sh "docker login -u $USER -p $PASS"
        }
        sh "docker push ${env.DOCKER_HUB_USER}/go-demo-2:beta-${env.BUILD_NUMBER}"
      }
    }
  }
}' | pbcopy

# TODO: Change [...]

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/go-demo-2/activity"

open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2/tags"