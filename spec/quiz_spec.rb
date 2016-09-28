require_relative "../quiz"

describe Classroom do
end

describe Curriculum do
    before(:example) do
        @id = 9
        @name = "Underwater Basketweaving"
        @question = Question.new(15, 0.73468)
        @new_question = Question.new(5, 0.34)
        @questions = {@question.id => @question,
                      @new_question.id => @new_question }
        @concept = Concept.new(1, "A1", @curriculum, @questions)
        @concepts = {@concept.id => @concept}
        @curriculum = @c = Curriculum.new(@id, @name, @concepts)
        @second_concept = Concept.new(2, "B2", @curriculum,
                                      { 3 => Question.new(3, 0.5) })
    end
    it "has an ID and name" do
        expect(@c.id).to be_kind_of(Integer)
        expect(@c.name).to be_kind_of(String)
        expect(@c.id).to eq(@id)
        expect(@c.name).to eq(@name)
    end

    it "can access its concepts" do
        expect(@c.concepts).not_to be_empty
        expect(@c.concepts[@concept.id]).to be(@concept)
    end

    it "can count its concepts" do
        expect(@c.concept_count).to be 1
    end

    it "can modify its concepts" do
        @c.concepts[@second_concept.id] = @second_concept
        expect(@c.concepts.keys).to include(@second_concept.id)
        expect(@c.concepts[@second_concept.id]).to be(@second_concept)
    end

    it "counts added concepts" do
        expect(@c.concept_count).to be 1
        @c.concepts[@second_concept.id] = @second_concept
        expect(@c.concept_count).to be 2
    end
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

    def questions_sorted?(question_list)
        question_list[0...-1].each_with_index.map do |q, idx|
            q.difficulty <= question_list[idx+1].difficulty
        end.all?
    end
    it "generates question lists sorted by difficulty" do
        @c.questions[@new_question.id] = @new_question
        list_question_objects = @c.question_list(6).map { |v| @c.questions[v] }
        expect(questions_sorted?(list_question_objects))
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
