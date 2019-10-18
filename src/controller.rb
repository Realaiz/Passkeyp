#frozen_string_literal: true

#######Gems#######
require 'colorize' 
require 'artii'
##################
require 'json' #json method library
class Users
    attr_accessor :service, :username, :password
    def initialize(service, username, password)
        @service = service
        @username = username
        @password = password
    end

    def constructHash
        {"service": @service, "username": @username, "password": @password}
    end 
end



class Main
    attr_accessor :users
    def initialize 
        welcomeMessage = Artii::Base.new 
        puts welcomeMessage.asciify("Passenger") #using artii gem to create ascii text welcome message
        puts "because like password + manager haha get it?"
        choice = ""
        until choice == "q" #escape function
            sleep(2) #all sleeps in the program are used to make the user experience more comfortable by slowing down the time between actions
            displayMenu
            case gets.strip 
            when "1" #This is the core behind the menu, based on user input calls a specific function #TODO: try change this to case switch maybe?
                sleep(0.5)
                listServices
            when "2"
                sleep(0.5)
                handleSearch
            when "3"
                sleep(0.5)
                addPassword
            when "4"
                sleep(0.5)
                removePassword
            when "5"
                sleep(0.5)
                generateRandomPassword
            else
                puts "Oops! That doesn't match a choice." #error handling
            end
        end
    end

    def displayMenu      
        puts "#===================(Select an option by typing a number)===================#"
        puts "type 'q' at any point to quit"
        menuOptions = ["List accounts", "Find password", "Add password", "Remove password", "Generate random password"]
        menuOptions.each_with_index {|element, index| puts "#{index+1} - #{element}\n".colorize(String.colors[rand(String.colors.length)])} #randomized colors to make menu less boring
    end

    def loadAccounts 
        fileData = File.read('passwords.json')
        jsontoRubyData = JSON.parse(fileData)
        users = jsontoRubyData.map do |user| #creates users array of Users objects for use later; from json file
          Users.new(user["service"], user["username"], user["password"])
        end 
        return users
    end

    def saveAccounts(users)
        rubytoJsonArray = users.map(&:constructHash) #ruby idiom which maps to the constructHash format
        File.open('passwords.json', 'w') do |f|  #opens json file and overrides the existing information, pretty_generate is just formatting tool
            f.write(JSON.pretty_generate(rubytoJsonArray))
        end
    end

    def listServices
        details = loadAccounts
        puts "#=================(Account Details)=================#"
        if details.empty? == false #checks if there are currently any account details stored
            details.each.with_index do |obj,index| #each value - obj, index - index || uses them to output a list of service names
                puts "#{index} - #{obj.service}"
            end
            handleIndexedOutput(details) #calls the handleindexed function to give more details if user wants
        else
            puts "nothing is stored currently"
        end
    end
#holy shit I did the search first try no bugs im a fkn smurf
    def handleSearch 
        details = loadAccounts
        puts "Enter a token to sort the accounts by (substring of service name):".colorize(:light_green) #using colorize gem to change the color of text output
        filterToken = gets.strip
        filteredArray = details.select {|item| (item.service).include? filterToken} #prunes array using select which takes a bool value, if false it deleted element from array
        findPassword(filteredArray) #using this array to perform a function similar to the one above
    end

    def findPassword(filteredArray)
        details = filteredArray #^^^^^^^
        if details.empty? == false 
            details.each.with_index do |obj,index|
                puts "#{index} - #{obj.service}"
            end
            handleIndexedOutput(details) #in this case the filteredarray is used as the arg for handleindex for dry scripting
        else
            puts "There is nothing matching the specified token"
        end
    end
    
    def handleIndexedOutput(details)
        puts "Enter an index number to see details"
        index = gets.strip.to_i
        sleep(1)
        puts "Username: #{(details[index]).username} \nPassword: #{(details[index]).password}"
    end

    def addPassword
        puts "#=================(ADD PASSWORD)=================#"
        puts "Enter the service name:"
        askService = gets.chomp #just chomp since name could have spaces
        puts "Enter the username:"
        askUsername = gets.strip
        puts "Enter the password:"
        askPassword = gets.strip
        
        importPassword(askService,askUsername,askPassword) #calls succeeding funcntion with user input as args
    end

    def importPassword(service, username, password)
        users = loadAccounts
        users << Users.new(service,username,password) #appends object into loaded array - users
        saveAccounts(users)
    end

    def removePassword
        users = loadAccounts
        
        puts "Remove an account (type index number):"
        removeIndex = gets.strip.to_i
        users.delete_at(removeIndex)
        saveAccounts(users)
    end

    def generateRandomPassword
        puts "#==================(Random Password Generator)===================#"
        p "Please enter the number of digits (default is 12):"
        digits = gets.to_i #strip not needed as the input is converted to integer
        p "Include uppercase? (y/n)"
        upcase = gets.strip #strip to remove newlines and spaces etc
        p "Include numbers (y/n)?"
        numbers = gets.strip
        p "Include special characters (y/n)?"
        special = gets.strip 

        upercasechar = ('A'..'Z').to_a
        numberchar = ('0'..'9').to_a
        specialchar = "@!%^()*+-&=#~?:;[]{}".split(//)
        characters = ('a'..'z').to_a
        if upcase == "y"
            characters += upercasechar #toggles which add charlist to char array
        end
        if numbers == "y"
            characters += numberchar
        end
        if special == "y"
            characters += specialchar
        end

        puts characters.sort_by {rand}.join[0...digits] #sorts array of selected characters randomly and displays 0-n digits of array
    end
end

run = Main.new #creates new instance of class Main and attaches it to the variable name.
run #runs the entire program