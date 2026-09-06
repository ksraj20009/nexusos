// ============================================================================
// Vajra OS — Calamares Installer Slideshow
// ============================================================================
// Shows during the installation process with Vajra OS features.
import QtQuick 2.15

Item {
    id: slideshow
    width: 800
    height: 400

    property int currentSlide: 0
    property var slides: [
        {
            title: "वज्र OS (Vajra OS)",
            subtitle: "India's Privacy-First AI-Powered Operating System",
            desc: "धर्मो रक्षति रक्षितः — Dharma protects those who protect it",
            color: "#e94560"
        },
        {
            title: "Privacy First",
            subtitle: "Your data never leaves your machine",
            desc: "No telemetry, no tracking, no cloud dependencies. Tor built-in for anonymous browsing.",
            color: "#0f3460"
        },
        {
            title: "Buddhi AI (बुद्धि)",
            subtitle: "India-first AI assistant",
            desc: "Voice-controlled, Indian language support, agentic task execution — all running locally.",
            color: "#e94560"
        },
        {
            title: "Indian Languages",
            subtitle: "हिंदी, तमिल, बंगाली, तेलुगु, मराठी, गुजराती, कन्नड़, मलयालम",
            desc: "Full system localization in all major Indian languages with Indian keyboard layouts.",
            color: "#0f3460"
        },
        {
            title: "Security Built-in",
            subtitle: "Firewall, encryption, antivirus, audit",
            desc: "One-click security hardening. UFW firewall, GPG encryption, ClamAV antivirus, AppArmor.",
            color: "#e94560"
        },
        {
            title: "Beginner & Pro Modes",
            subtitle: "Two ways to use Vajra OS",
            desc: "Beginner mode: safety guardrails, large icons, sudo blocked. Pro mode: full access, dev tools, root shell.",
            color: "#0f3460"
        },
        {
            title: "Indian Features",
            subtitle: "GST calculator, Panchang, Ayurveda, Vedic Math",
            desc: "Built-in tools for Indian users — festival calendar, IRCTC status, UPI integration, and more.",
            color: "#e94560"
        },
        {
            title: "Free & Open Source",
            subtitle: "Everything is local and free",
            desc: "No paid services. No cloud lock-in. 320+ tools and utilities, all open source.",
            color: "#0f3460"
        }
    ]

    Timer {
        interval: 4000
        running: true
        repeat: true
        onTriggered: {
            slideshow.currentSlide = (slideshow.currentSlide + 1) % slideshow.slides.length
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#1a1a2e"

        Rectangle {
            id: accentBar
            width: parent.width
            height: 4
            color: slides[currentSlide].color
            anchors.top: parent.top
            Behavior on color { ColorAnimation { duration: 500 } }
        }

        Text {
            id: title
            text: slides[currentSlide].title
            color: slides[currentSlide].color
            font.pixelSize: 36
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 60
            Behavior on color { ColorAnimation { duration: 500 } }
        }

        Text {
            id: subtitle
            text: slides[currentSlide].subtitle
            color: "#ffffff"
            font.pixelSize: 22
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: title.bottom
            anchors.topMargin: 20
        }

        Text {
            id: desc
            text: slides[currentSlide].desc
            color: "#a3a3a3"
            font.pixelSize: 16
            wrapMode: Text.WordWrap
            width: parent.width - 100
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: subtitle.bottom
            anchors.topMargin: 30
        }

        // Progress dots
        Row {
            spacing: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: slides.length
                Rectangle {
                    width: 10
                    height: 10
                    radius: 5
                    color: index === currentSlide ? slides[currentSlide].color : "#444444"
                    Behavior on color { ColorAnimation { duration: 500 } }
                }
            }
        }

        Text {
            text: "वज्र"
            color: "#222244"
            font.pixelSize: 120
            font.bold: true
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: -20
            z: -1
        }
    }

    Behavior on currentSlide {
        NumberAnimation {
            duration: 500
            easing.type: Easing.InOutQuad
        }
    }
}
