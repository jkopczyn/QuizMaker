require_relative "../quiz"

describe Classroom do
end

describe Curriculum do
end

describe Concept do
    before(:example) do
        @id = 7
        @name = "TestNamePleaseIgnore"
        @curriculum = Curriculum.new(3, "")
        @question = Question.new(15, 0.73468)
        @questions = {@question.id => @question}
        @concept = @c = Concept.new(@id, @name, @curriculum, @questions)
        @new_question = Question.new(5, 0.34)
    end
    it "has an ID and name" do
        expect(@c.id).to be_kind_of(Integer)
        expect(@c.name).to be_kind_of(String)
        expect(@c.id).to eq(@id)
        expect(@c.name).to eq(@name)
    end

    it "can access its parent curriculum" do
        expect(@c.curriculum).to be(@curriculum)
    end

    it "can access its questions" do
        expect(@c.questions).not_to be_empty
        expect(@c.questions[@question.id]).to be(@question)
    end

    it "can count its questions" do
        expect(@c.question_count).to be 1
    end

    it "can modify its questions" do
        @c.questions[@new_question.id] = @new_question
        expect(@c.questions.keys).to include(@new_question.id)
        expect(@c.questions[@new_question.id]).to be(@new_question)
    end

    it "counts added questions" do
        expect(@c.question_count).to be 1
        @c.questions[@new_question.id] = @new_question
        expect(@c.question_count).to be 2
    end

    it "generates question lists" do
        @c.questions[@new_question.id] = @new_question
        list = @c.question_list(6)
        expect(list.length).to be 6
        expect(list).to include(@new_question.id, @question.id)
    end
end

describe Question do
    before(:example) do
        @id = 3
        @difficulty = 0.4
    end
    it "has an ID and difficulty" do
        q = Question.new(@id, @difficulty)
        expect(q.id).to be_kind_of(Integer)
        expect(q.id).to eq(@id)
        expect(q.difficulty).to be_kind_of(Float)
        expect(q.difficulty).to eq(@difficulty)
    end

    it "knows about the associated concept" do
        concept = Concept.new(1, "Dummy")
        q = Question.new(@id, @difficulty, concept)
        expect(q.concept).to be(concept)
    end
end

describe Student do
end
