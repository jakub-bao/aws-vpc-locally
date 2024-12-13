function_name=okta-test-python
zip_file=out/main.zip
invoke_output=out/remote.out
handler=main.main
cert_location=.venv/lib/python3.12/site-packages/certifi

awscert:
	cp cert/aws_z.pem $(cert_location)/
	mv $(cert_location)/aws_z.pem $(cert_location)/cacert.pem

set_handler:
	aws lambda update-function-configuration --function-name $(function_name) --handler main.main

requirements:
	cp src/requirements.txt build
	cd build && pip3 install --upgrade --target . -r ./requirements.txt

zip:
	rm -f $(zip_file)
	cp src/* build/
	cd build && zip ../$(zip_file) *

deploy: zip
	aws lambda update-function-code --function-name $(function_name) --zip-file fileb://$(zip_file)

invoke:
	aws lambda invoke --function-name $(function_name)  $(invoke_output)
	cat $(invoke_output)

run:
	. .venv/bin/activate; python3 -c 'from src.main import main; print(main("test-event","test-context"))'