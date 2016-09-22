class Classroom:
    def initialize(filename=nil):
        @strands = {}
        @users = {}
        if filename:
            file = File.open(filename, "r")
            self.parse(file) if file
        end
    end

    def generate_quiz_for_user(id, how_many):
        user = @users[id]
        return [0]*how_many if user
    end

    private
    def parse(file):
    end
end
