package server;

import cmd.GameServerCommands;
import rmi.RMIServices;
import rmi.RMIServicesImpl;
import util.Helper;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.rmi.AlreadyBoundException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;

public class GameServer {
    private int PORT;
    private ServerSocket socket = null;
    private GomokuServer gomokuServer;
    private GameServerCommands gameServerCommands;

    public GameServer(int svPort) {
        PORT = svPort;
        gameServerCommands = new GameServerCommands();
        gomokuServer = new GomokuServer();
    }

    /**
     * Initializes the server
     */
    public boolean init() {
        try {
            initServerCommands();
            socket = new ServerSocket(PORT);

            if (!Helper.initAdminJwt()) {
                System.out.println("Failed to get JWT for server!");
                return false;
            }

            RMIServices rmiServices = new RMIServicesImpl(gameServerCommands);
            RMIServices stub = (RMIServices) UnicastRemoteObject.exportObject(rmiServices, 0);
            Registry registry = LocateRegistry.createRegistry(1099);
            registry.bind("RmiServices", stub);
            return true;
        } catch (IOException e) {
            System.out.println("Error when creating the server socket!");
            return false;
        } catch (AlreadyBoundException e) {
            System.out.println("Error when activating the rmi services");
            return false;
        }
    }

    /**
     * Waits for new clients
     */
    public void waitForClients() {
        try {
            System.out.println("Listening at port " + PORT);
            while (true) {
                Socket clientSocket = socket.accept();
                new Thread(new ClientThread(clientSocket, gameServerCommands, gomokuServer)).start();
            }
        } catch (IOException e) {
            System.out.println("Error when accepting a client");
        } finally {
            try {
                if (socket != null) {
                    socket.close();
                }
            } catch (IOException e) {
                System.out.println(e.getMessage());
            }
        }
    }

    /**
     * Initializes the server commands
     */
    private void initServerCommands() {
        gameServerCommands.addCommand("register", "register username password", false);
        gameServerCommands.addCommand("login", "login username password", false);
        gameServerCommands.addCommand("create", "create roomName", true);
        gameServerCommands.addCommand("ai-game", "ai-game roomName", true);
        gameServerCommands.addCommand("join", "join roomId", true);
        gameServerCommands.addCommand("list-rooms", true);
        gameServerCommands.addCommand("list-rmi", true);
        gameServerCommands.addCommand("logout", true);
        gameServerCommands.addCommand("quit", false);
        gameServerCommands.addCommand("quit", true);
    }
}
