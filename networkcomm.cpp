#include "networkcomm.h"
#include<QtNetwork/QNetworkAccessManager>
#include<QtNetwork/QNetworkReply>
#include<QtNetwork/QNetworkRequest>
#include<QDebug>
#include<QUrlQuery>
#include<QHttpPart>
#include<QFile>

NetworkComm::NetworkComm(QObject *parent) :
    QThread(parent)
{

    nam = new QNetworkAccessManager(this);
    QObject::connect(nam, SIGNAL(finished(QNetworkReply*)),
             this, SLOT(finishedSlot(QNetworkReply*)));
    m_token="";
    multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
}

void NetworkComm::addImage(QString key, const QByteArray value){
    QHttpPart* imagePart;
    imagePart = new QHttpPart();
    imagePart->setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\""+key+"\"; filename=\"myfile.jpg\""));
    imagePart->setHeader(QNetworkRequest::ContentTypeHeader, QVariant("image/jpeg"));
    QFile *file = new QFile(value);
    file->open(QIODevice::ReadOnly);
    imagePart->setBodyDevice(file);
    file->setParent(multiPart);
    multiPart->append(*imagePart);
    //params.addQueryItem(key,value);
}

void NetworkComm::addFile(QString key, const QByteArray value, const QByteArray file_extension, const QByteArray file_type){
    QHttpPart* filePart;
    filePart = new QHttpPart();
    filePart->setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\""+key+"\"; filename=\""+"myfile."+file_extension+"\""));
    filePart->setHeader(QNetworkRequest::ContentTypeHeader, QVariant(file_type));
    QFile *file = new QFile(value);
    file->open(QIODevice::ReadOnly);
    filePart->setBodyDevice(file);
    file->setParent(multiPart);
    multiPart->append(*filePart);
}

void NetworkComm::addParam(QString key, const QByteArray value){
    QHttpPart* http_part;
    http_part = new QHttpPart();
    //http_part->setHeader(QNetworkRequest::ContentTypeHeader, QVariant("text/plain"));
    http_part->setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\""+key+"\""));
    http_part->setBody(value);
    multiPart->append(*http_part);
    //params.addQueryItem(key,value);
}

void NetworkComm::sendPostRequest(QString addr){

    QByteArray qbt;
    QByteArray token_inqba;
    //qbt.append(params.query(QUrl::FullyEncoded));
    qDebug()<<"The encoded: "<<qbt;
    QUrl url(addr);
    QNetworkRequest qnr=QNetworkRequest(url);
    //qnr.setHeader(QNetworkRequest::ContentTypeHeader,QVariant("application/x-www-form-urlencoded"));
    qDebug()<<"The m_token is: "<<m_token;
    if(m_token!=""){
        token_inqba.append("Token "+m_token);
        qnr.setRawHeader("AUTHORIZATION", token_inqba);
        qDebug()<<"Token appended: "<<m_token;
    }
    else{
        qDebug()<<"Token not appended: "<<m_token;
    }
    rply = nam->post(qnr,multiPart);
    //params.clear();
    //Enabeling the below two lines cause the app to crash
    //delete(multiPart);
    //multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
    qDebug()<<"post request to "<<addr;
    emit networkSend();
}

void NetworkComm::setToken(const QString &t){
    //qDebug()<<"Will set the token: ";
    if (t != m_token) {
        m_token = t;
        emit tokenChanged();
    }
}

QString NetworkComm::token() {
    return m_token;
}


void NetworkComm::sendGetRequest(QString s){
    QUrl url(s);
    rply = nam->get(QNetworkRequest(url));
    qDebug()<<"get request to "<<s;
}


void NetworkComm::finishedSlot(QNetworkReply * reply){
    QByteArray bytes = reply->readAll();  //.readAll();  // bytes
    QString string(bytes); // string
    qDebug()<<"reply: "<<string<<".................";
    emit networkReply(string);
    delete(multiPart);
    multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

}



