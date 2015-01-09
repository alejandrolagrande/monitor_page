class WelcomeController < ApplicationController

  Task = Struct.new(:name, :start, :finish, :percent_complete)
  $task = [] 
  def index
    parse_file
  end

  private
  
  def parse_file
    f = File.open("/var/www/html/website/app/controllers/F89A_REAC_InstallationProjectPlan_9_9_1_0.xml")
    doc = Nokogiri::XML(f)
    parse_xml(doc)
  end

  def parse_xml(doc)
    doc.root.elements.each do |node|
      parse_tasks(node)
    end
  end

  def parse_tasks(node)
    if node.node_name.eql? 'Tasks'
      node.elements.each do |node|
        parse_task(node)
      end
    end
  end

  def parse_task(node)
    if node.node_name.eql? 'Task'
      node.elements.each do |node|
        $name = node.text.to_s if node.name.eql? 'Name'
        $start = node.text.to_s if node.name.eql? 'Start'
        $finish = node.text.to_s if node.name.eql? 'Finish'
        $percent_complete = node.text.to_s if node.name.eql? 'PercentComplete'
        
        if $name != nil && $start != nil && $finish != nil && $percent_complete != nil
          $task << Task.new($name, $start, $finish, $percent_complete)
          $name = nil
          $start = nil
          $finish = nil
          $percent_complete = nil
        end
      end
    end
  end
end
