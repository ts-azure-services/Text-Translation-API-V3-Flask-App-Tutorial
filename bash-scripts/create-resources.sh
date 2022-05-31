#!/bin/bash
#Script to provision Cognitive Services account
grn=$'\e[1;32m'
end=$'\e[0m'

# Start of script
SECONDS=0

# Source subscription ID, and prep config file
source sub.env
sub_id=$SUB_ID

# Set the default subscription 
az account set -s $sub_id

# Create the resource group, location
number=$[ ( $RANDOM % 100000 ) + 1 ]
resourceGroup='cs'$number
translatorService='cs'$number'translator'
speechService='cs'$number'speech'
textService='cs'$number'text'
location='westus2'

printf "${grn}STARTING CREATION OF RESOURCE GROUP...${end}\n"
rgCreate=$(az group create --name $resourceGroup --location $location)
printf "Result of resource group create:\n $rgCreate \n"

## Create translator text service
printf "${grn}CREATING THE TRANSLATOR TEXT SERVICE...${end}\n"
textTranslatorCreate=$(az cognitiveservices account create \
	--name $translatorService \
	-g $resourceGroup \
	--kind 'TextTranslation' \
	--sku S1 \
	--location $location)
printf "Result of text translator create:\n $textTranslatorCreate \n"

## Retrieve translator key 
printf "${grn}RETRIEVE KEYS & ENDPOINTS FOR SPEECH AND TRANSLATOR SERVICE...${end}\n"
translatorKey=$(az cognitiveservices account keys list -g $resourceGroup --name $translatorService --query "key1")
translatorLocation=$(az cognitiveservices account show -g $resourceGroup --name $translatorService --query "location")

## Create speech services
printf "${grn}CREATING THE SPEECH SERVICE...${end}\n"
speechServicesCreate=$(az cognitiveservices account create \
	--name $speechService \
	-g $resourceGroup \
	--kind 'SpeechServices' \
	--sku S0 \
	--location $location)
printf "Result of speech services create:\n $speechServicesCreate \n"

## Retrieve translator key 
printf "${grn}RETRIEVE KEYS & ENDPOINTS FOR SPEECH SERVICE...${end}\n"
speechKey=$(az cognitiveservices account keys list -g $resourceGroup --name $speechService --query "key1")
speechLocation=$(az cognitiveservices account show -g $resourceGroup --name $speechService --query "location")

## Create text analytics
printf "${grn}CREATING THE TEXT ANALYTICS SERVICE...${end}\n"
textAnalyticsCreate=$(az cognitiveservices account create \
	--name $textService \
	-g $resourceGroup \
	--kind 'TextAnalytics' \
	--sku S \
	--location $location)
printf "Result of text analytics create:\n $textAnalyticsCreate \n"

## Retrieve translator key 
printf "${grn}RETRIEVE KEYS & ENDPOINTS FOR TEXT ANALYTICS...${end}\n"
textKey=$(az cognitiveservices account keys list -g $resourceGroup --name $textService --query "key1")
textLocation=$(az cognitiveservices account show -g $resourceGroup --name $textService --query "location")

# Create environment file for endpoints and keys
printf "${grn}WRITING OUT ENVIRONMENT VARIABLES...${end}\n"
configFile='variables.env'
printf "RESOURCE_GROUP=$resourceGroup \n"> $configFile
printf "TRANSLATOR_NAME=$translatorService \n">> $configFile
printf "TRANSLATOR_KEY=$translatorKey \n">> $configFile
printf "TRANSLATOR_LOCATION=$translatorLocation \n">> $configFile
printf "SPEECH_NAME=$speechService \n">> $configFile
printf "SPEECH_KEY=$speechKey \n">> $configFile
printf "SPEECH_LOCATION=$speechLocation \n">> $configFile
printf "TEXT_ANALYTICS_NAME=$textService \n">> $configFile
printf "TEXT_ANALYTICS_KEY=$textKey \n">> $configFile
printf "TEXT_ANALYTICS_LOCATION=$textLocation \n">> $configFile

printf "${grn}GREAT JOB. INFRA ALL SETUP.........${end}\n"
sleep 10 # just to give time for artifacts to settle in the system, and be accessible
