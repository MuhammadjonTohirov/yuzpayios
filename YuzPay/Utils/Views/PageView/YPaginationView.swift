//
//  YPaginationView.swift
//  YuzPay
//
//  Created by applebro on 23/01/23.
//

import UIKit
import SwiftUI

struct PageView<Page: View>: View {
    var viewControllers: [UIHostingController<Page>]
    @Binding var currentPage: Int
    
    init(_ views: [Page], _ page: Binding<Int>) {
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
        self._currentPage = page
    }

    var body: some View {
        VStack(alignment: .center) {
            PageViewController(controllers: viewControllers, currentPage: $currentPage)   
        }
    }
}

struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    @Binding var currentPage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.currentPageIndicatorTintColor = .blue
        control.pageIndicatorTintColor = .gray
        control.tintColor = .accent
        control.pageIndicatorTintColor = .accent.withAlphaComponent(0.3)
        control.currentPageIndicatorTintColor = .accent
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
}

struct PageViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIPageViewController
    
    var controllers: [UIViewController]
    @Binding var currentPage: Int
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers([self.controllers[currentPage]], direction: .forward, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        
        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            
            if index == 0 {
                return parent.controllers.last
            }
            
            return parent.controllers.item(at: index - 1)
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            
            if index + 1 == parent.controllers.count {
                return parent.controllers.first
            }
            
            return parent.controllers.item(at: index + 1)
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = parent.controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
    }
}

struct YPaginationView_Preview: PreviewProvider {
    @State static var page: Int = 0
    static var previews: some View {
        VStack {
            Text("page \(page)")
            PageView([
                Rectangle().foregroundColor(.systemBlue),
                Rectangle().foregroundColor(.systemRed),
                Rectangle().foregroundColor(.systemOrange),
            ], $page)
        }
    }
}
