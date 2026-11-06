import SwiftUI

struct ClockWidgetView: View {
    @State private var currentDate = Date()
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var pcHostname: String

    var body: some View {
        VStack(spacing: 8) {
            // Main Time
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(hoursString)
                    .font(.system(size: 46, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#1D1D1F"))

                Text(":")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#1D1D1F"))
                    .opacity(secondsInt % 2 == 0 ? 1.0 : 0.4)

                Text(minutesString)
                    .font(.system(size: 46, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#1D1D1F"))

                Text(ampmString)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#86868B"))
                    .padding(.leading, 4)
            }

            // Seconds Track Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.black.opacity(0.06))
                        .frame(height: 3)

                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(hex: "#0071E3"))
                        .frame(width: max(0, min(geo.size.width, geo.size.width * CGFloat(secondsInt + 1) / 60.0)), height: 3)
                        .animation(.easeOut(duration: 0.3), value: secondsInt)
                }
            }
            .frame(width: 130, height: 3)

            // Date String
            Text(dateString)
                .font(.system(size: 13, weight: .semibold, design: .default))
                .tracking(0.8)
                .foregroundColor(Color(hex: "#86868B"))
                .padding(.top, 2)

            // PC status badge
            HStack(spacing: 4) {
                Text("💻")
                    .font(.system(size: 11))
                Text(pcHostname)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "#6E6E73"))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color.black.opacity(0.04))
            .cornerRadius(10)
            .padding(.top, 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white.opacity(0.65))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
        .onReceive(timer) { input in
            currentDate = input
        }
    }

    private var hoursString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h"
        return formatter.string(from: currentDate)
    }

    private var minutesString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter.string(from: currentDate)
    }

    private var ampmString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        return formatter.string(from: currentDate)
    }

    private var secondsInt: Int {
        Calendar.current.component(.second, from: currentDate)
    }

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: currentDate).uppercased()
    }
}
