class QuizViewController < UIViewController

  def init
    super
    @current_question_index = 0
    @questions = [ 'What is 7 + 7?', 'What is the capital of the UK?', 'What is cognac made from?']
    @answers = [ '14', 'London', 'Grapes' ]
    self
  end

  def viewDidLoad
    # can't call self.margin because margin is a private method
    @question_label = add_to_view( build_label(@questions.first, margin, 50, width, 40) )
    @question_button = add_to_view( build_button('Show Question', margin, 100, width, 30) )

    @answer_label = add_to_view( build_label('???', margin, 300, width, 40) )
    @answer_button = add_to_view( build_button('Show Answer', margin, 350, width, 30) )

    @question_button.addTarget(self, action:'question_action', forControlEvents:UIControlEventTouchUpInside)
    @answer_button.addTarget(self, action:'answer_action', forControlEvents:UIControlEventTouchUpInside)
  end


  private

  def width
    self.view.frame.size.width - (margin * 2)
  end

  def margin
    @margin = 20
  end

  def add_to_view(component)
    self.view.addSubview(component)
    component
  end

  def build_label(text, x, y, width, height)
    new_label = UILabel.new
    new_label.text = text
    new_label.textAlignment = UITextAlignmentCenter
    # frame position and size - (x, y, width, hight), or [[x, y], [width, height]]
    new_label.frame = [[x, y], [width, height]]
    new_label
  end

  def build_button(text, x, y, width, height)
    new_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    new_button.setTitle(text, forState:UIControlStateNormal)
    # frame position and size - (x, y, width, hight), or [[x, y], [width, height]]
    new_button.frame = [[x, y], [width, height]]
    new_button
  end

  def question_action
    @current_question_index = (@current_question_index + 1) % @questions.count
    @question_label.text = @questions[@current_question_index]
    @answer_label.text = '???'
  end

  def answer_action
    @answer_label.text = @answers[@current_question_index]
  end


end
