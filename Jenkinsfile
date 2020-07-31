pipeline {
	agent any
	stages {
		stage('Lint HTML') {
			steps {
				sh 'tidy -q -e *.html'
			}
		}
		
		stage('Building Docker Image') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockercredentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh '''
						docker build -t kalyani297/capstoneproject .
					'''
				} 
 
			}
		}

		stage('Pushing Image To Dockerhub') {
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockercredentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
					sh '''
						docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
						docker push kalyani297/capstoneproject
					'''
				}
			}
		}

		stage('Set Current kubectl Context') {
			steps {
				withAWS(region:'us-west-2', credentials:'awscredentials') {
					sh '''
						kubectl config use-context arn:aws:eks:us-west-2:187540882151:cluster/capstonecluster
						
					'''
				}
			}
		}

		stage('Blue Deployment') {
			steps {
				withAWS(region:'us-west-2', credentials:'awscredentials') {
					sh '''
						kubectl apply -f ./kubernetes/blue-deployment.yml
					'''
				}
			}
		}

		stage('Green Deployment') {
			steps {
				withAWS(region:'us-west-2', credentials:'awscredentials') {
					sh '''
						kubectl apply -f ./kubernetes/green-deployment.yml
					'''
				}
			}
		}

		stage('Blue Deployment Service') {
			steps {
				withAWS(region:'us-west-2', credentials:'awscredentials') {
					sh '''
						kubectl apply -f ./kubernetes/blue-service.yml
					'''
				}
			}
		}



		stage('Green Deployment Service') {
			steps {
				withAWS(region:'us-west-2', credentials:'awscredentials') {
					sh '''
						kubectl apply -f ./kubernetes/green-service.yml
					'''
				}
			}
		}

	}
}
