package com.nativecodex.ncxtunnel.vpn

enum class VpnStatus {
    Stopped,
    Starting,
    Started,
    Stopping;

    val nativeName: String get() = name
}
