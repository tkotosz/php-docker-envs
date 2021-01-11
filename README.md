# php-docker-envs

dev env, customized version of https://github.com/paslandau/docker-php-tutorial

# setup environment
```
make docker-up
```

# install magento
```
make docker-console
composer install
bin/magento setup:install --admin-email "kotosy+magento@gmail.com" --admin-firstname "admin" --admin-lastname "admin" --admin-password "admin123" --admin-user "admin" --backend-frontname admin --base-url "http://docker-test-project.local/" --db-host database --db-name magento --db-user magento --db-password magento --session-save files --use-rewrites 1 --use-secure 0 --search-engine=elasticsearch7 --elasticsearch-host=elasticsearch --elasticsearch-port=9200
bin/magento module:disable Magento_TwoFactorAuth
bin/magento setup:upgrade
```

# install fresh magento
```
rm -rf project/*
make docker-console
composer global require hirak/prestissimo
composer create-project --repository=https://repo.magento.com/ magento/project-community-edition .
bin/magento setup:install --admin-email "kotosy+magento@gmail.com" --admin-firstname "admin" --admin-lastname "admin" --admin-password "admin123" --admin-user "admin" --backend-frontname admin --base-url "http://docker-test-project.local/" --db-host database --db-name magento --db-user magento --db-password magento --session-save files --use-rewrites 1 --use-secure 0 --search-engine=elasticsearch7 --elasticsearch-host=elasticsearch --elasticsearch-port=9200
bin/magento module:disable Magento_TwoFactorAuth
bin/magento setup:upgrade
```

# Use redis for the session & cache
```
bin/magento setup:config:set --session-save=redis --session-save-redis-host='redis-session' --session-save-redis-port='6379' --session-save-redis-db=1
bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server='redis-cache' --cache-backend-redis-port='6379' --cache-backend-redis-db=2
bin/magento setup:config:set --page-cache=redis --page-cache-redis-server='redis-cache' --page-cache-redis-port='6379' --page-cache-redis-db=3
```
