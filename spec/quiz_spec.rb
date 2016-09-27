require_relative "../quiz"

describe Classroom do
end

describe Curriculum do
end

describe Concept do
end

describe Question do
    it "has an ID and difficulty" do
        id = 3
        difficulty = 0.4
        q = Question.new(id, difficulty)
        expect(q.id).to be_kind_of(Integer)
        expect(q.id).to eq(id)
        expect(q.difficulty).to be_kind_of(Float)
        expect(q.difficulty).to eq(difficulty)
    end

    it "knows about the associated concept" do
        id = 3
        difficulty = 0.4
        concept = Concept.new(1, "Dummy")
        q = Question.new(id, difficulty, concept)
        expect(q.concept).to be(concept)
    end
end

describe Student do
end
