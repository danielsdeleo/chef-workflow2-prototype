BASEDIR=$(dirname $0)

cp $BASEDIR/../skeletons/updated_demo_files/Berksfile .wf2/Berksfile
cp $BASEDIR/../skeletons/updated_demo_files/Vagrantfile .wf2/Vagrantfile

cp $BASEDIR/../skeletons/updated_demo_files/default.rb cookbooks/demo/recipes/default.rb
cp $BASEDIR/../skeletons/updated_demo_files/metadata.rb cookbooks/demo/metadata.rb

cp $BASEDIR/../skeletons/updated_demo_files/Policyfile Policyfile

