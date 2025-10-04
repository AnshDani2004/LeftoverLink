import Foundation

/// Returns a human‑friendly string representing the time elapsed since the
/// provided date. Examples include "just now", "5m ago", "2h ago", or
/// "3d ago". Larger units like weeks are used for long intervals.
func timeAgo(from date: Date) -> String {
    let seconds = Int(Date().timeIntervalSince(date))
    if seconds < 60 {
        return "Just now"
    }
    let minutes = seconds / 60
    if minutes < 60 {
        return "\(minutes)m ago"
    }
    let hours = minutes / 60
    if hours < 24 {
        return "\(hours)h ago"
    }
    let days = hours / 24
    if days < 7 {
        return "\(days)d ago"
    }
    let weeks = days / 7
    return "\(weeks)w ago"
}