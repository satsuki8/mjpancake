import QtQuick 2.0
import rolevax.sakilogy 1.0
import "../widget"

Column {
    id: frame

    signal authOk
    property bool frozen: false

    spacing: global.size.space

    TexdInput {
        id: unInput
        textLength: 8
        hintText: "用户名"
        enabled: !frozen
        validator: RegExpValidator { regExp: /^[[a-zA-Z0-9_\-]{4,32}$/ }
        KeyNavigation.tab: pwInput
        onTextChanged: {
            loginErrorText.text = "";
        }
        onAccepted: {
            pwInput.focus = true;
        }
    }

    TexdInput {
        id: pwInput
        textLength: 8
        hintText: "密码"
        enabled: !frozen
        validator: RegExpValidator { regExp: /^.{8,32}$/ }
        echoMode: TextInput.Password
        KeyNavigation.tab: unInput
        onTextChanged: {
            loginErrorText.text = "";
        }
        onAccepted: {
            loginButton.clicked();
        }
    }

    Buzzon {
        id: loginButton
        textLength: 8
        text: frozen ? "灵压吓人中……" : "上线"
        enabled: !frozen && unInput.acceptableInput && pwInput.acceptableInput
        onClicked: {
            frozen = true;
            PClient.login(unInput.text, pwInput.text);
        }
    }

    Texd {
        id: loginErrorText
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Connections {
        target: PClient

        onAuthFailIn: {
            loginErrorText.text = reason;
            frame.frozen = false;
        }
    }
}