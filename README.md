# 仿天猫超市轮播器
###初始化: 
      ####控制器中写:
      let (v,success) = CarouselView.create(frame:CGRectZero,dataSource:[String]())
      success ? view.addSubview(v) : fatalError()
