require 'test/unit'
require_relative 'controller.rb'

class UsersTest < Test::Unit::TestCase
    def test_Users
        user = Users.new("youtube","powername","12345")
        assert_equal("youtube",user.service)
        assert_equal("powername",user.username)
        assert_equal("12345",user.password)
    end

    def test_constructHash
        user = Users.new("hashservice","hashuser","hashpass")
        obj = user.constructHash
        assert_instance_of Hash, obj
        assert_equal(obj[:"service"],"hashservice")
        assert_equal(obj[:"username"],"hashpass")
        assert_equal(obj[:"password"],"hashuser")
    end
end