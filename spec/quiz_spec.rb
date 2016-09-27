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
    end
    it "has an ID and name" do
        c = Concept.new(@id, @name)
        expect(c.id).to be_kind_of(Integer)
        expect(c.name).to be_kind_of(String)
        expect(c.id).to eq(@id)
        expect(c.name).to eq(@name)
    end

    it "can access its parent curriculum" do
        c = Concept.new(@id, @name, @curriculum)
        expect(c.curriculum).to be(@curriculum)
    end

    it "can access its questions" do
        question_id = 15
        question = Question.new(question_id, 0.73468)
        c = Concept.new(@id, @name, @curriculum, {question_id => question})
        expect(c.questions).not_to be_empty
        expect(c.questions[question_id]).to be(question)
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
