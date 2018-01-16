# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'JKQuickDevelop' do
# Uncomment the next line if you're using Swift or would like to use dynamic frameworks
# use_frameworks! 
    
    # 公共常用的第三方类库（根据github上作者指示更新版本）
    # 图片加载
    # https://github.com/rs/SDWebImage.git
    pod 'SDWebImage'
    
    # 转换速度快、使用简单方便的字典转模型框架
    # https://github.com/CoderMJLee/MJExtension
    pod 'MJExtension'

    # 网络请求库
    # https://github.com/AFNetworking/AFNetworking
    pod 'AFNetworking'

    # 下拉刷新
    # https://github.com/CoderMJLee/MJRefresh
    pod 'MJRefresh'

    # 自动布局
    # https://github.com/SnapKit/Masonry.git
    pod 'Masonry'
    
    # HUD
    # https://github.com/jdg/MBProgressHUD
    pod 'MBProgressHUD'

    # 键盘遮挡文字
    # https://github.com/hackiftekhar/IQKeyboardManager
    pod 'IQKeyboardManager' #iOS8 and later
    
    # 覆盖在NavigationBar的Toast
    # https://github.com/cruffenach/CRToast
    pod 'CRToast', '~> 0.0.7'

    # 很方便使用的键值监听器
    # https://github.com/facebook/KVOController
    pod 'KVOController'

    # UITableView数据为空导向图
    #  https://github.com/dzenbot/DZNEmptyDataSet
    pod 'DZNEmptyDataSet'

    # Categories分类
    # https://github.com/shaojiankui/JKCategories
    pod 'JKCategories'
    
    # UITableView为空时使用
    # https://github.com/dzenbot/DZNEmptyDataSet
    pod 'DZNEmptyDataSet'
    
    # 小红点控件
    # https://github.com/weng1250/WZLBadge
    pod 'WZLBadge'
    
    # IOS评分集成
    # https://github.com/arashpayan/appirater
    pod 'Appirater'
    
    # IOS缓存库
    # https://github.com/ibireme/YYCache
    pod 'YYCache'
    
    # Fackbook动画库
    # https://github.com/facebook/pop
    pod 'pop', '~> 1.0'
    
    # 富文本展示
    # https://github.com/ibireme/YYKit
    pod 'YYText'
    pod 'YYImage'
    
    # yykit开源库
    # https://github.com/ibireme/YYKit
    # pod 'YYKit'
    
    # 照片浏览选择器
    # https://github.com/mwaterfall/MWPhotoBrowser
    # pod 'MWPhotoBrowser', '~> 2.1'


    # 照片浏览选择器
    # https://github.com/longitachi/ZLPhotoBrowser#%E6%95%88%E6%9E%9C%E5%9B%BE
    pod 'ZLPhotoBrowser'
    
    # RAC 项目框架
    # https://github.com/ReactiveCocoa/ReactiveObjC
    pod 'ReactiveObjC', '~> 3.0'

    # UIView 离屏渲染
    # https://github.com/liuzhiyi1992/ZYCornerRadius
    pod 'ZYCornerRadius', '~> 1.0.2'
    
    
    # 私有的的第三方类库（根据自己的业务需求）
    
    # 滚动轮播
    # https://github.com/stackhou/YJBannerViewOC
    pod 'YJBannerView'
    
    # 分页View PageIndicator
    pod 'SGPagingView', '~> 1.3'
    
    # cell自动高度
    pod 'UITableView+FDTemplateLayoutCell'
    
    # UITextView+PlaceHolder
    pod 'UITextView+Placeholder', '~> 1.2'
    
    # 对话框
    pod 'LEEAlert'
    
    # 网页加载显示进度
    # https://github.com/ninjinkun/NJKWebViewProgress
    pod 'NJKWebViewProgress'
    
    # 自动布局
    pod 'SDAutoLayout', '~> 2.1.3'
    pod 'MyLayout', '~> 1.5.0'
    
  # Pods for JKQuickDevelop

  target 'JKQuickDevelopTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
   end
end
