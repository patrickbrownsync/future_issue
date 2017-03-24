$thread_pool = Concurrent::ThreadPoolExecutor.new(
    min_threads: 5,
    max_threads: 15,
    max_queue: 100,
    fallback_policy: :caller_runs
)