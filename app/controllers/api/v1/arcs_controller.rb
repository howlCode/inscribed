module Api
  module V1
    class ArcsController < ApplicationController
      before_action :authorize_access_request!, except: [:all_unvoted_arcs, :all_voted_arcs, :index, :show]
      before_action :load_story, except: [:all_unvoted_arcs, :all_voted_arcs]
      before_action :set_arc, except: [:all_unvoted_arcs, :all_voted_arcs, :create, :index]

      def all_unvoted_arcs
        @arcs = Arc.where(inscribed: false)
        render json: @arcs.as_json(include: [:story, :user, :votes_for, :get_upvotes, :get_downvotes, :inscribed])
      end

      def all_voted_arcs
        @arcs = Arc.where(inscribed: true)
        render json: @arcs.as_json(include: [:story, :user, :votes_for, :get_upvotes, :get_downvotes, :inscribed])
      end

      def index
        @arcs = @story.arcs.all
        render json: @arcs.as_json(include: [:user, :votes_for, :get_upvotes, :get_downvotes, :inscribed])
      end

      def show
        render json: @arc.as_json(include: [:story, :user, :votes_for, :get_upvotes, :get_downvotes, :inscribed])
      end

      def create
        @arc = current_user.arcs.build(arc_params)

        if @arc.save
          render json: @arc, status: :created, location: api_v1_story_arc_path(@story, @arc)
        else
          render json: @arc.errors, status: :unprocessable_entity
        end
      end

      def update
        if @arc.update(arc_params)
          render json: @arc
        else
          render json: @arc.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @arc.destroy
      end

      def upvote
        @arc = Arc.find(params[:id])
        if !@arc.inscribed
          @arc.upvote_by current_user
          render json: {
            arc: @arc.as_json(include: [:get_upvotes, :get_downvotes]),
            message: "Vote saved",
            error: "Vote was not saved"
          }
        else
          render json: {
            error: "Voting has ended"
          }
        end
      end

      def downvote
        @arc = Arc.find(params[:id])
        if !@arc.inscribed
          @arc.downvote_by current_user
            render json: {
              arc: @arc.as_json(include: [:get_upvotes, :get_downvotes]),
              message: "Vote saved",
              error: "Vote was not saved"
          }
        else
          render json: {
            error: "Voting has ended"
          }
        end
      end 

      private

        def set_arc
          @arc = @story.arcs.find(params[:id])
        end

        def load_story
          @story = Story.find(params[:story_id])
        end

        def arc_params
          params.require(:arc).permit(:body, :story_id)
        end
    end
  end
end