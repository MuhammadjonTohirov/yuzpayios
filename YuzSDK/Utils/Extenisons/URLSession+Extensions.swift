//
//  URLSession+Extensions.swift
//  YuzPay
//
//  Created by applebro on 23/02/23.
//

import Foundation

extension URLSession {
    func cancelAllTasks() async {
        await self.allTasks.forEach({ task in
            task.cancel()
        })
    }
}
