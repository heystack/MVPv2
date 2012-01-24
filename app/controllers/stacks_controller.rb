class StacksController < ApplicationController
  include ActionView::Helpers::NumberHelper

  # Required to prevent session from resetting, due to use of 'def protect_from_forgery? false' in mvp_mailer_helper 
  skip_before_filter :verify_authenticity_token

  def new
    if signed_in?
      @stack = Stack.new
      @title = "Create New Stack"
    else
      flash[:notice] = "You must first sign in order to create a new Stack Category."
      redirect_to root_path
    end
  end

  def create
    if signed_in?
      @stack = Stack.new(params[:stack])
      if @stack.save
        flash[:success] = "Stack Created!"
        redirect_to @stack
      else
        @title = "Create a New Stack"
        render 'new'
      end
    else
      flash[:notice] = "You must first sign in order to create a new Stack."
      redirect_to root_path
    end
  end

  def show
    if !signed_in?
      redirect_to root_path
    end

    @stack = Stack.find(params[:id])

    if !@stack
      redirect_to new_stack_path
    end
    
    session[:stack] = @stack.id
    @stacks = Stack.all

    if @stack.answered?(current_user)
      @response = Response.find_by_stack_id_and_user_id(@stack.id, current_user.id)
      session[:you] = @response.value
      @comments = @stack.comments.all
      @comment = Comment.new
    else
      redirect_to new_stack_response_path(@stack) and return
    end

    # Not sure what would cause a zero, but seems to be happening, so check for it
    if session[:you] < 0.0001
      redirect_to new_stack_response_path(@stack)
    end
    
    @user = current_user

    @lowest_color = LOWEST_COLOR
    @all_neighbors_color = ALL_NEIGHBORS_COLOR
    @you_color = YOU_COLOR
    @biggest_color = BIGGEST_COLOR

    @count = @stack.responses.count

    # @tipping_point_progress = ("%.0f" % ((@count.to_f / TIPPING_POINT) * 100)).to_s + "%"
    
    if @count > 0
      # Calculate all_neighbors
      @all_neighbors = @stack.responses.average(:value)
      # Used for debug purposes only
      @responses = @stack.responses.all(:order => 'value')

      # TODO: There must be an easier way to calculate the top and bottom 20%!!
      @count_20_percent = (0.20 * @count).ceil

      # Calculate lowest_spenders
      @lowest_amounts = @stack.responses.order('value ASC').limit(@count_20_percent)
      @lowest_total = 0
      @lowest_amounts.each { |a| @lowest_total += a.value }
      @lowest_amt = @lowest_total / @count_20_percent

      # Calculate biggest_spenders
      @biggest_amounts = @stack.responses.order('value DESC').limit(@count_20_percent)
      @biggest_total = 0
      @biggest_amounts.each { |a| @biggest_total += a.value }
      @biggest_amt = @biggest_total / @count_20_percent
      
      # Calculate user_rank
      if session[:you] <= @lowest_amt
        @user_rank = "lowest"
      elsif session[:you] <= @all_neighbors
        @user_rank = "average"
      elsif session[:you] < @biggest_amt
        @user_rank = "more than most"
      else
        @user_rank = "biggest"
      end
      
      # Calculate percent_diff
      if @user_rank == "lowest"
        @percent = (( @lowest_amt - session[:you] ) / @lowest_amt) * 100
        @percent_diff = ("%.f" % @percent).to_s + "%"
      else
        @percent = (( session[:you] - @lowest_amt ) / @lowest_amt) * 100
        @percent_diff = ("%.f" % @percent).to_s + "%"
      end

      # Calculate mult_diff
      if @user_rank == "lowest"
        # Not sure what would cause a zero, but seems to be happening, so check for it
        if session[:you] < 0.0001
          flash[:error] = "Response must be greater than zero."
          @mult = 0.0
        else
          @mult = ( @lowest_amt / session[:you] ).round
        end
      else
        @mult = ( session[:you] / @lowest_amt ).round
      end
      if @mult == 0.5
        @mult_diff = "half as much"
      elsif @mult > 0.5 && @mult < 1.75
        @mult_diff = "slightly"
      elsif @mult >= 1.75 && @mult < 2
        @mult_diff = "almost twice as much"
      elsif @mult == 2
        @mult_diff = "twice as much"
      elsif @mult < 3
        @mult_diff = "more than twice as much"
      else
        @mult_diff = "at least " + ("%.f" % @mult).to_s + " times"
      end

      # Generate stack-specific text for display
      if @stack.stem == "How much"
        if @user_rank == "lowest"
          # @diff_amt = (( @lowest_amt - session[:you] ) * 240).round
          @diff_text = "&nbsp;less"
        else
          # @diff_amt = (( session[:you] - @lowest_amt ) * 240).round
          @diff_text = "&nbsp;more"
        end
        if @diff_amt == 0
          @comparison_text = @stack.attr_comparison_1 + " <span class='em'>the same as</span> " + @stack.attr_comparison_2
          # @diff_text = ""
        else
          @diff_amt = number_to_currency(@diff_amt, :strip_insignificant_zeros => true)
          @comparison_text = @stack.attr_comparison_1 + " <span class='em'>" + @percent_diff + @diff_text + "</span> " + @stack.attr_comparison_2
          # @diff_text = "With four 5 hours sits per month, you spend <span class='em'>" + @diff_amt.to_s + @diff_text + " per year</span> than your lowest spending neighbors."
        end
        @lowest_desc = "Least"
        @highest_desc = "Highest"

      elsif @stack.stem == "At what age"
        if @user_rank == "lowest"
          @diff_amt = ( @lowest_amt - session[:you] ).round
          @diff_text = "about " + help.pluralize(@diff_amt, 'year') + " earlier"
        else
          @diff_amt = ( session[:you] - @lowest_amt ).round
          @diff_text = "about " + help.pluralize(@diff_amt, 'year') + " later"
        end
        if @diff_amt == 0
          @comparison_text = @stack.attr_comparison_1 + " <span class='em'>at the same age</span> " + @stack.attr_comparison_2
          # @diff_text = ""
        else
          @comparison_text = @stack.attr_comparison_1 + " <span class='em'>" + @diff_text + "</span> " + @stack.attr_comparison_2
          # @diff_text = "Based on an average child's cell phone use, your child may spend up to <span class='em'>" + "6 hours per week" + "</span> on their cell phone."
        end
        @lowest_desc = "Youngest"
        @highest_desc = "Oldest"

      elsif @stack.stem == "How many"
        if @user_rank == "lowest"
          @diff_amt = (( @lowest_amt - session[:you] ) * 21).round
          @diff_text = "&nbsp;less"
        else
          @diff_amt = (( session[:you] - @lowest_amt ) * 21).round
          @diff_text = "&nbsp;more"
        end
        if @diff_amt == 0
          @comparison_text = @stack.attr_comparison_1 + " <span class='em'>the same as</span> " + @stack.attr_comparison_2
          # @diff_text = ""
        else
          @comparison_text = @stack.attr_comparison_1 + " <span class='em'>" + @mult_diff + @diff_text + "</span> " + @stack.attr_comparison_2
          # @diff_text = "In a typical month, your child may spend up to <span class='em'>" + @diff_amt.to_s + @diff_text + "</span> hours on homework than their least loaded peers."
        end
        @lowest_desc = "Lowest"
        @highest_desc = "Highest"

      end

      if @stack.attr_rounding == ".0"
        @hc_tooltip = "this.x + this.point.name + ': " + @stack.attr_tooltip_prefix + "'+ this.y.toFixed(1).gsub(\"" + @stack.attr_rounding + "\", \"\") +'" + @stack.attr_tooltip_units + "'"
        @hc_dataLabel = "'" + @stack.attr_tooltip_prefix + "'+ this.y.toFixed(1).gsub(\"" + @stack.attr_rounding + "\", \"\")"
      elsif @stack.attr_rounding == ".00"
        @hc_tooltip = "this.x + this.point.name + ': " + @stack.attr_tooltip_prefix + "'+ this.y.toFixed(2).gsub(\"" + @stack.attr_rounding + "\", \"\") +'" + @stack.attr_tooltip_units + "'"
        @hc_dataLabel = "'" + @stack.attr_tooltip_prefix + "'+ this.y.toFixed(2).gsub(\"" + @stack.attr_rounding + "\", \"\")"
      else
        @hc_tooltip = "this.x + this.point.name + ': " + @stack.attr_tooltip_prefix + "'+ this.y +'" + @stack.attr_tooltip_units + "'"
        @hc_dataLabel = "'" + @stack.attr_tooltip_prefix + "'+ this.y'"
      end

    else
      @new_stack = true
      @hc_tooltip = "this.x +': '+ this.y.toFixed(1).gsub(\".0\", \"\") +''"
      @hc_dataLabel = "''+ this.y.toFixed(1).gsub(\".0\", \"\")"
    end
  end

  def edit
    @title = "Edit Stack"
    @stack = Stack.find(params[:id])
  end
  
  def update
    @stack = Stack.find(params[:id])
    if @stack.update_attributes(params[:stack])
      flash[:success] = "Stack updated."
      redirect_to @stack
    else
      render 'edit'
    end
  end

  def create_stack
    @title = "Create New Stack (Work In Progress)"
    @stack = Stack.new
  end
  
end
