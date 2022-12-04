;;; (openai client) --- Guile OpenAI client.

;; Copyright (C) 2022 Aleix Conchillo Flaque <aconchillo@gmail.com>
;;
;; This file is part of guile-openai.
;;
;; guile-openai is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3 of the License, or
;; (at your option) any later version.
;;
;; guile-openai is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with guile-openai. If not, see https://www.gnu.org/licenses/.

;;; Commentary:

;; OpenAI module for Guile.

;;; Code:

(define-module (openai client)
  #:use-module (openai types)
  #:use-module (ice-9 receive)
  #:use-module (rnrs bytevectors)
  #:use-module (srfi srfi-9)
  #:use-module (web client)
  #:use-module (json)
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

;;; (openai client) ends here
