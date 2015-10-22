#include <QtGui/QGuiApplication>
#include <QDebug>
#include <QQmlContext>
#include<QQmlEngine>
#include"networkcomm.h"
#include<QDir>
#include<QScreen>
#include<QObject>
#include<QQuickView>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>


int main(int argc, char *argv[])
{
     QGuiApplication app(argc, argv);
     QQmlApplicationEngine engine;
     qmlRegisterType<NetworkComm>("Networking", 1, 0, "Networkcomm");
     engine.load(QUrl("qrc:/main.qml"));
     QObject *topLevel = engine.rootObjects().value(0);
     QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
     //engine.load(QUrl("qrc:/main.qml"));
     window->show();
     return app.exec();
}
