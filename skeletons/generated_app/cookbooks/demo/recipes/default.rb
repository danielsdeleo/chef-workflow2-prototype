ruby_block "hello message" do
  block do
    $stdout.puts "\n\n" + ("* " * 40) + "\n Howdy, Chef!"
  end
end
