install:
	bundle
	bundle exec appraisal install
	bundle exec appraisal rails-7.2 ruby bin/prepare_dummy_test_db
	npm install eslint @eslint/js

eslint:
	npx eslint . --ignore-pattern spec/dummy/vendor/

test:
	bundle exec appraisal rspec
