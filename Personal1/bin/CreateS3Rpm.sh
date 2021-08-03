#!/bin/bash
TF=YES
APP1=nol-api-cis-stub
APP=noltf
VERSION="1.0.${CI_PIPELINE_ID}"
RELEASE=1
WORKING=/builds/nol-ntc-r/nolntc-terraforms

export AWS_DEFAULT_REGION=eu-west-2

InitialiseTempWorkingDir()
{
    echo `date '+%d/%m/%Y_%H:%M:%S'` - Initialising local temporary working directory .....
    if [ -d $APP ] ; then
        echo removing old directory $APP
        rm -rf  $APP
    fi
    echo creating $APP
    echo path is 
    pwd
    mkdir $APP
}

LoginToDockerECR()
{
    echo `date '+%d/%m/%Y_%H:%M:%S'` - Logon onto docker ECR
    eval "$(aws ecr get-login --no-include-email --region eu-west-2)"
}

SaveDockerECRImageAsTarFile()
{
    echo `date '+%d/%m/%Y_%H:%M:%S'` - Saving Docker image as a tar file ...
    docker pull $ECRIMAGE
    docker save $ECRIMAGE  > $APP/$APP.tar
}

CreatSPECFileForRPMFile()
{
    SPECFILENAME=$APP/$APP.spec
    echo SPECFILENAME: $SPECFILENAME
    echo `date '+%d/%m/%Y_%H:%M:%S'` - Creating SPEC file $SPECFILENAME ...
    echo  ######################### >  $SPECFILENAME
    echo Name: $APP >>  $SPECFILENAME
    echo Version: $VERSION >> $SPECFILENAME
    echo Release: $RELEASE >> $SPECFILENAME
    echo License: My license >> $SPECFILENAME
    echo Summary: RPM Package for $APP ECR Creation  >> $SPECFILENAME
    echo  >> $SPECFILENAME
    echo %description>> $SPECFILENAME
    echo create docker image $APP  >> $SPECFILENAME
    echo >>  $SPECFILENAME
    echo %prep >>  $SPECFILENAME
    echo >>  $SPECFILENAME
    echo %build >>  $SPECFILENAME
    echo %install >>  $SPECFILENAME
    echo mkdir -p %{buildroot}/$APP >>  $SPECFILENAME
    echo cp -R $WORKING/$APP/* %buildroot/$APP/ >>  $SPECFILENAME
    echo >>  $SPECFILENAME
    echo %clean >>  $SPECFILENAME
    echo >>  $SPECFILENAME
    echo %files >>  $SPECFILENAME
    echo /$APP/* >>  $SPECFILENAME
    echo >>  $SPECFILENAME
    echo ################### >>  $SPECFILEANAME

}

CreateRPMFile ()
{
    echo `date '+%d/%m/%Y_%H:%M:%S'` - Creating  RPM file ...
    if ! [ -d  RPMBUILD ] ; then
    echo installing rpm build components via yum ...
    #sudo yum -y install gcc rpm-build rpm-devel rpmlint make python bash coreutils diffutils patch rpmdevtools
    echo creating RPM-BUILD folder structure
    #rpmdev-setuptree
    mkdir -p ~/rpmbuild/SOURCES ~/rpmbuild/SPECS ~/rpmbuild/BUILDROOT 
    echo finished creating  RPMBUILD folder structure
    fi
    echo Creating RPM file from $SPECFILENAME
    rpmbuild -ba $SPECFILENAME
}


CreateManifestFile ()
{
    echo `date '+%d/%m/%Y_%H:%M:%S'`  - Creating manifest file manifest-$VERSION.yml
    echo "---" >  manifest-$VERSION.yml
    echo "version: '$VERSION'"  >>  manifest-$VERSION.yml
    echo "packages:" >>  manifest-$VERSION.yml
    echo "- name: $APP" >>  manifest-$VERSION.yml
    echo "  version: $VERSION" >>  manifest-$VERSION.yml
    echo "  release: $RELEASE" >>  manifest-$VERSION.yml
    echo "  architecture: x86_64" >>  manifest-$VERSION.yml
}

PublishToS3Bucket ()
{
    echo `date '+%d/%m/%Y_%H:%M:%S'`  - Pushing rpm and manifest file to S3 bucket
    echo files that have been packaged up in the rpm file are:
    rpm -qlp ~/rpmbuild/RPMS/x86_64/$APP-$VERSION-$RELEASE.x86_64.rpm
    aws s3 cp ~/rpmbuild/RPMS/x86_64/$APP-$VERSION-$RELEASE.x86_64.rpm s3://dwp-cloudservices-nolntc-deploy-test/pipeline/
    aws s3 cp manifest-$VERSION.yml s3://dwp-cloudservices-nolntc-deploy-test/manifests/
}

PrepareTFFiles ()
{
    echo `date '+%d/%m/%Y_%H:%M:%S'`  -  Copying TF files from TF folder to $APP folder ...
    cp -R * $APP/
}


### 
# Main body of script starts here
###

InitialiseTempWorkingDir
if  [ $TF != YES ] ; then
    LoginToDockerECR
    SaveDockerECRImageAsTarFile 
fi

if  [ $TF = YES ] ; then
    PrepareTFFiles
fi

CreatSPECFileForRPMFile
CreateRPMFile
CreateManifestFile
PublishToS3Bucket
