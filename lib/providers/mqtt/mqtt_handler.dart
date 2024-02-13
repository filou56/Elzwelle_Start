import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttHandler with ChangeNotifier {
  final ValueNotifier<String> data = ValueNotifier<String>("");
  late  MqttServerClient client;

  var id = UniqueKey();

  Future<Object> connect() async {
    client = MqttServerClient.withPort(
        '144db7091e4a45cbb0e14506aeed779a.s2.eu.hivemq.cloud', 'elzwelle_$id', 8883);
    // client = MqttServerClient.withPort(
    //     '144db7091e4a45cbb0e14506aeed779a.s2.eu.hivemq.cloud', 'elzwelle_start', 8883);
    client.logging(on: false);
    client.onConnected      = onConnected;
    client.onDisconnected   = onDisconnected;
    client.onUnsubscribed   = onUnsubscribed;
    client.onSubscribed     = onSubscribed;
    client.onSubscribeFail  = onSubscribeFail;
    client.pongCallback     = pong;
    client.keepAlivePeriod  = 60;
    client.connectTimeoutPeriod = 10;
    /// HiveMQ uses TLS secure transport
    client.secure           = true;
    client.securityContext  = SecurityContext.defaultContext;
    client.onBadCertificate = (dynamic a) => true;
    /// Set the correct MQTT protocol for mosquito
    client.setProtocolV311();

    final connMessage = MqttConnectMessage()
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    print('MQTT_LOGS::Mosquitto client connecting....');

    client.connectionMessage = connMessage;
    try {
      /// HiveMQ uses password authentication
      await client.connect('welle', 'elzwelle');
    } catch (e) {
        print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT_LOGS::Mosquitto client connected');
    } else {
      print(
          'MQTT_LOGS::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      return -1;
    }

    sleep(const Duration(seconds: 1));

    print('MQTT_LOGS::Subscribing to the elzwelle/stopwatch/start topic');
    const topic = 'elzwelle/stopwatch/start/#';
    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final rcvMessage = c![0].payload as MqttPublishMessage;
      final rcfPayload = MqttPublishPayload.bytesToStringAsString(rcvMessage.payload.message);

      if (c[0].topic == 'elzwelle/stopwatch/start') {
        data.value = rcfPayload;
      } else {
        // use unique string to force notify listeners
        data.value = DateTime.now().millisecond.toString();
      }
      notifyListeners();
    });

    return client;
  }

  void onConnected() {
    print('MQTT_LOGS:: Connected');
  }

  void onDisconnected() {
    print('MQTT_LOGS:: Disconnected');
  }

  void onSubscribed(String topic) {
    print('MQTT_LOGS:: Subscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    print('MQTT_LOGS:: Failed to subscribe $topic');
  }

  void onUnsubscribed(String? topic) {
    print('MQTT_LOGS:: Unsubscribed topic: $topic');
  }

  void pong() {
    print('MQTT_LOGS:: Ping response client callback invoked');
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    }
  }
}
