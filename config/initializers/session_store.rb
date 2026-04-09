Rails.application.config.session_store :cache_store,
                                       servers: ["redis://localhost:6379/0/session"],
                                       expire_after: 90.minutes,
                                       key: "_sprava_majetku_session",
                                       threadsafe: true
