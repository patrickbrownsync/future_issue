class LiveController < ApplicationController
  include ActionController::Live

  def test
    response.headers['Content-Type'] = 'text/event-stream'

    sse = response.stream

    while true
      begin
        Concurrent.future(default_executors = $thread_pool) do
          Rails.application.executor.wrap do
            a = Test.new(user_id: 1)
            a.save!
            a.id
          end
        end.on_success do |result|
          Rails.application.executor.wrap do
            sse.write "success: #{result} \n\n"
          end
        end.on_failure do |reason|
          Rails.application.executor.wrap do
            sse.write "failure: #{reason} \n\n"
          end
        end
        sleep 10
        logger.info "Thread Pool:\nscheduled: #{$thread_pool.scheduled_task_count}\ncompleted: #{$thread_pool.completed_task_count}\nqueue_length: #{$thread_pool.queue_length}\nremaining_capacity: #{$thread_pool.remaining_capacity}\nIn Progress: #{@in_progress.inspect}\n\n\n"
      rescue => e
        logger.info e.to_s + " - promise error\n\n\n\n"
        sse.write e.to_s
      end
    end

    sse.close
  end
end
