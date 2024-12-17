# lambda function name within aws
function_name=okta-test
zip_file=out/main.zip
# log file location after remote lambda invoke
invoke_output=out/remote.out
# path to a python method which will be executed on lambda invoke
handler=main.main
# cacert.pem locations
venv_cert_location=.venv/lib/python3.12/site-packages/certifi
build_cert_location=build/certifi
# invoke lambda manually
run=python3 -c 'from main import main; print(main("test-event","test-context"))'

# make sure build & cert tasks are executed even if a directory with the same name exists
.PHONY: build cert

# update cacert.pem with one which includes a zscaler root certificate
# update cacert.pem in .venv & in build
cert:
	cp cert/cacert.pem $(venv_cert_location)/
	cp cert/cacert.pem $(build_cert_location)/

get_config:
	aws lambda get-function-configuration --function-name $(function_name) > out/conf.json
	cat out/conf.json

# change lambda configuration to execute a different handler function
configure:
	aws lambda update-function-configuration --function-name $(function_name) --handler main.main
	aws lambda update-function-configuration --function-name $(function_name) --timeout 5

# install python dependencies into the build dir
requirements:
	cp src/requirements.txt build
	cd build && pip3 install --upgrade --target . -r ./requirements.txt

build:
	rm -f $(zip_file)
	cp src/*.py build/
	cd build && zip -r ../$(zip_file) *


deploy: build
	aws lambda update-function-code --function-name $(function_name) --zip-file fileb://$(zip_file)

# run lambda from the src dir
run:
	. .venv/bin/activate; cd src; $(run)

# run lambda from the build dir
preview:
	cd build && $(run)

# execute lambda as deployed in aws
invoke:
	aws lambda invoke --function-name $(function_name)  $(invoke_output)
	cat $(invoke_output) | jq