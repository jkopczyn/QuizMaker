I'm unclear on the purpose of the usage file. Should a student get exclusively questions from that file if it's supplied? That is a possible implication but may not be correct. Looking at the file doesn't help; it has the information described and nothing else.

I'm going to operate under the assumption that all assigned but unanswered questions (in a Standard/Strand) should be assigned before any other.

Oh, wait, that's in the bonus requirements. And parsing the CSVs is _optional_. Sure, technically. I'm doing it anyway, that's obviously the Right Thing.


Structure:

parse the questions into objects. Classes: Strand, Standard, Question, User.
Quiz class? Probably. Overarching Classroom class to hold everything.

Strand has:
    id
    name
    standards
    standard_count
    question_count
possibly also:
    questions (through standards)

Standard has:
    id
    name
    strand
    questions
    question_count

Question has:
    id
    standard
    difficulty (probably unused initially, but why not, we're parsing it)

Classroom has:
    strands
    users
    initialize(file=None)
        private parse(filename)
    generate_quiz_for_user(id, how_many)

User has:
    id
    classroom
initially just that, not going to parse usages for v1

Quiz has:
    initialize(user, strands)
    populate_quiz(how_many_questions)
    print_questions
