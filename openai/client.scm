
(define-module (openai client)
  #:use-module (ice-9 receive)
  #:use-module (json)
  #:use-module (rnrs bytevectors)
  #:use-module (srfi srfi-9)
  #:use-module (web client)
  #:export (make-client
            client-organization
            client-api-key
            list-models
            retrieve-model
            create-completion
            create-edit
            create-moderation))

(define openai-base-url "https://api.openai.com/v1")

;;
;; API types
;;
(define-json-type <permission>
  (id)
  (created)
  (allow-create-engine "allow_create_engine")
  (allow-sampling "allow_sampling")
  (allow-logprobs "allow_logprobs")
  (allow-search-indices "allow_search_indices")
  (allow-view "allow_view")
  (allow-fine-tuning "allow_fine_tuning")
  (organization)
  (group)
  (is-blocking "is_blocking"))

(define-json-type <model>
  (id)
  (created)
  (owned-by "owned_by")
  (permission "permission" #(<permission>))
  (root)
  (parent))

(define-json-type <models-list>
  (data "data" #(<model>)))

(define-json-type <choice>
  (text)
  (index)
  (logprobs)
  (finish-reason "finish-reason"))

(define-json-type <usage>
  (prompt-tokens "prompt_tokens")
  (completion-tokens "completion_tokens")
  (total-tokens "total_tokens"))

(define-json-type <text-completion>
  (id)
  (created)
  (model)
  (choices "choices" #(<choice>))
  (usage "usage" <usage>))

(define-json-type <edit>
  (created)
  (choices "choices" #(<choice>))
  (usage "usage" <usage>))

(define-json-type <categories>
  (hate)
  (hate/threatening)
  (self-harm)
  (sexual)
  (sexual/minors)
  (violence)
  (violence/graphic))

(define-json-type <result>
  (categories "categories" <categories>)
  (category-scores "category_scores" <categories>))

(define-json-type <moderation>
  (id)
  (model)
  (results "results" #(<result>)))

;;
;; Public
;;
;; TODO: it's all the same so just create a macro.
;;

(define-record-type <openai-client>
  (make-openai-client organization api-key)
  openai-client?
  (organization client-organization)
  (api-key client-api-key))

(define* (make-client api-key #:key (organization #f))
  (make-openai-client organization api-key))

(define (list-models client)
  (receive (response body)
      (get-request client "/models")
    (call-with-input-string
        (if (string? body) body (utf8->string body))
      json->models-list)))

(define (retrieve-model client model)
  (receive (response body)
      (get-request client (string-append "/models/" model))
    (call-with-input-string
        (if (string? body) body (utf8->string body))
      json->model)))

(define (create-completion client body)
  (receive (response body)
      (post-request client "/completions/" body)
    (call-with-input-string
        (if (string? body) body (utf8->string body))
      json->text-completion)))

(define (create-edit client body)
  (receive (response body)
      (post-request client "/edits" body)
    (call-with-input-string
        (if (string? body) body (utf8->string body))
      json->edit)))

(define (create-moderation client body)
  (receive (response body)
      (post-request client "/moderations" body)
    (call-with-input-string
        (if (string? body) body (utf8->string body))
      json->moderation)))

;;
;; Utils
;;

(define (get-request client path)
  (http-get (string-append openai-base-url path)
            #:headers (get-headers client)))

(define (post-request client path body)
  (http-post (string-append openai-base-url path)
             #:body (string->utf8 (scm->json-string body))
             #:headers (post-headers client)))

(define (get-headers client)
  (if (client-organization client)
      `((Authorization . ,(string-append "Bearer " (client-api-key client)))
        (OpenAI-Organization . ,(client-organization client)))
      `((Authorization . ,(string-append "Bearer " (client-api-key client))))))

(define (post-headers client)
  (append (get-headers client) '((Content-Type . "application/json"))))
