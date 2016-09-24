#Academic Quiz Generator

Given a CSV file containing questions organized into concepts, which are organized into curriculums, this creates a model for creating quizzes out of those questions.

Given an additional file for data on which questions individual students have seen, this can be customized to give questions the student has not seen yet.

##Usage

### Data Format

The question file should be organized as follows:
First row: Header. Should contain the columns
    curriculum_id, curriculum_name, concept_id, concept_name, question_id, difficulty
All proceeding rows should be comma-separated and follow this schema.

### Calling

The file can be run individually with ruby with 2-4 arguments. Example: `ruby quiz.rb questions.csv 20 3 students.csv` will generate 20 questions for student #3 using `questions.csv` for question data and `students.csv` for data on what student 3 has seen in the past. Student ID and data are optional (and currently nonfunctional).
