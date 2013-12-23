require 'spec_helper'

describe 'demo::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge("demo::default") }
  
  it "updates the hello file" do
    expect(chef_run).to render_file('/tmp/hello-file').with_content("Howdy, Chef!")
  end
end
