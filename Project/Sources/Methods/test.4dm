//%attributes = {}



TRUNCATE TABLE:C1051([Cache:7])

$cache:=ds:C1482.Request.calculateCache()
build_cache("global"; $cache.cache.first.stmp; $cache.cache.last.stmp)
build_cache("process"; $cache.cache.first.stmp; $cache.cache.last.stmp)
build_cache("user"; $cache.cache.first.stmp; $cache.cache.last.stmp)
build_cache("host"; $cache.cache.first.stmp; $cache.cache.last.stmp)