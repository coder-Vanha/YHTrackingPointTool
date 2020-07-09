# YHTrackingPointTool

#背景
UITableView & UICollectionView 每次在reload方法执行后 cellwillDisplay方法也会走多次，而我们上传曝光埋点一般会在这个方法里做，为了防止重复曝光，写了个小工具
#用法
请见代码注解
