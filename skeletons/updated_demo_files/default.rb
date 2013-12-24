ruby_block "hello message" do
  block do
    $stdout.puts "\n\n" + ("* " * 40) + "\n #{node["hello-message"]}"
  end
end

include_recipe "postgresql"
