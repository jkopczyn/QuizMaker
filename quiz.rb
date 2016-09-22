class Classroom
    def initialize(filename=nil)
        @strands = {}
        @users = {}
        if filename
            file = File.open(filename, "r")
            self.parse(file) if file
        end
    end

    def generate_quiz_for_user(id, how_many)
        user = @users[id]
        return [0]*how_many if user
    end

    private
    def parse(file)
        expected_header = [:strand_id,:strand_name,:standard_id,:standard_name,:question_id,:difficulty]
        header = file.readline.split(",").map(:to_sym)
        raise "Bad Format" unless header == expected_header
        file.readlines.each do |line|
            strand_id,strand_name,standard_id,standard_name,question_id,difficulty = line.split(",")
            unless @strands[strand_id]
            end
        end
    end
end
