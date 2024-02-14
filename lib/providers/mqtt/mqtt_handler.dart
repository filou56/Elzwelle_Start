import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttHandler with ChangeNotifier {
  final ValueNotifier<String> data = ValueNotifier<String>("");
  late  MqttServerClient _client;

  var id = UniqueKey();

  Future<Object> connect() async {
    _client = MqttServerClient.withPort(
        '144db7091e4a45cbb0e14506aeed779a.s2.eu.hivemq.cloud', 'elzwelle_$id', 8883);
    // client = MqttServerClient.withPort(
    //     '144db7091e4a45cbb0e14506aeed779a.s2.eu.hivemq.cloud', 'elzwelle_start', 8883);
    _client.logging(on: false);
    _client.onConnected      = onConnected;
    _client.onDisconnected   = onDisconnected;
    _client.onUnsubscribed   = onUnsubscribed;
    _client.onSubscribed     = onSubscribed;
    _client.onSubscribeFail  = onSubscribeFail;
    _client.pongCallback     = pong;
    _client.keepAlivePeriod  = 60;
    _client.connectTimeoutPeriod = 10;
    /// HiveMQ uses TLS secure transport
    _client.secure           = true;
    _client.securityContext  = SecurityContext.defaultContext;
    _client.onBadCertificate = (dynamic a) => true;
    /// Set the correct MQTT protocol for mosquito
    _client.setProtocolV311();

    final connMessage = MqttConnectMessage()
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    print('MQTT_LOGS::Mosquitto client connecting....');

    _client.connectionMessage = connMessage;
    try {
      /// HiveMQ uses password authentication
      await _client.connect('welle', 'elzwelle');
    } catch (e) {
        print('Exception: $e');
      _client.disconnect();
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT_LOGS::Mosquitto client connected');
    } else {
      print(
          'MQTT_LOGS::ERROR Mosquitto client connection failed - disconnecting, status is ${_client.connectionStatus}');
      _client.disconnect();
      return -1;
    }

    sleep(const Duration(seconds: 1));

    print('MQTT_LOGS::Subscribing to the elzwelle/stopwatch/start topic');
    const topic = 'elzwelle/stopwatch/start/#';
    _client.subscribe(topic, MqttQos.atMostOnce);

    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final rcvMessage = c![0].payload as MqttPublishMessage;
      final rcfPayload = MqttPublishPayload.bytesToStringAsString(rcvMessage.payload.message);

      if (c[0].topic == 'elzwelle/stopwatch/start') {
        data.value = rcfPayload+' *'; // + Tag
      } else if (c[0].topic == 'elzwelle/stopwatch/start/number/akn') {
        data.value = rcfPayload+' #'; // + Tag
      } else if (c[0].topic == 'elzwelle/stopwatch/start/number/error') {
        data.value = rcfPayload+' !'; // + Tag
      }else {
        // use unique string to force notify listeners
        data.value = DateTime.now().millisecondsSinceEpoch.toString();
      }
      notifyListeners();
    });

    return _client;
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

    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      _client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    }
  }
}
