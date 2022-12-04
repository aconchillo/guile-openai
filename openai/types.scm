;;; (openai types) --- Guile OpenAI types.

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

(define-module (openai types)
  #:use-module (json)
  #:export (make-permission
            permission?
            json->permission
            permission->json

            make-model
            model?
            json->model
            model->json

            make-models-list
            models-list?
            json->models-list
            models-list->json

            make-choice
            choice?
            json->choice
            choice-list->json

            make-usage
            usage?
            json->usage
            usage->json

            make-text-completion
            text-completion?
            json->text-completion
            text-completion->json

            make-edit
            edit?
            json->edit
            edit->json

            make-categories
            categories?
            json->categories
            categories->json

            make-result
            result?
            json->result
            result->json

            make-moderation
            moderation?
            json->moderation
            moderation->json))

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
  (finish-reason "finish_reason"))

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

;;; (openai types) ends here
