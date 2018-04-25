    function ParticleSwarm(Func::Function,nVariables,nParticles,Range;InertialW=1.0,InertialDump = 0.9,PersonalW=2.0,GlobalW=2.0,MaxIter=100,GlobalPar=false)
    #Func - Function to be minimized
    #nVariables - Number of Problem's variables
    #nParticles - Number of used particles
    #Range - Range of starting position
    #Inertialw, PersonalW, GlobalW - Last velocity, Best particle position and global best position weights, respectively
    #GlobalPar - Boolean Parameter, [false] - Considers global direction quadrant (include Rand), [true] - Considers global velocity direction

    #Initialization
    VelocityT = zeros(nVariables,nParticles)                                    #Velocity vector at instant T
    PositionT = rand(nVariables,nParticles).*(Range[2]-Range[1]) + Range[1]     #Position vector at instant T
    FuncVal = zeros(nParticles)                                                 #Function values

    for i = 1:nParticles
        FuncVal[i] = Func(PositionT[:,i])[1]
    end

    PersonalBestFunc = FuncVal                                                      #Personal Best function value of each particle
    GlobalBestFunc = minimum(FuncVal)                                               #Global Best function value of all particles
    PersonalBestPosition = PositionT                                                #Personal Best position of each particle
    GlobalBestPosition = PositionT[:,indmin(FuncVal)]                               #Global Best position of all particles

    #Main Loop

    for i = 1:MaxIter

        for j = 1:nParticles

            if GlobalPar
                VelocityT[:,j] = InertialW.*rand(nVariables).*VelocityT[:,j] +
                                   PersonalW*rand(nVariables).*(PersonalBestPosition[:,j] - PositionT[:,j]) +
                                   GlobalW*rand().*(GlobalBestPosition - PositionT[:,j])
            else
                VelocityT[:,j] = InertialW.*rand(nVariables).*VelocityT[:,j] +
                                   PersonalW*rand(nVariables).*(PersonalBestPosition[:,j] - PositionT[:,j]) +
                                   GlobalW*rand(nVariables).*(GlobalBestPosition - PositionT[:,j])
            end

            PositionT[:,j] = PositionT[:,j] + VelocityT[:,j]
            FuncVal[j] = Func(PositionT[:,j])[1]

            if (FuncVal[j] < PersonalBestFunc[j])
                PersonalBestFunc[j] = FuncVal[j]
                PersonalBestPosition[:,j] = PositionT[:,j]
            end

        end

        if (minimum(FuncVal) < GlobalBestFunc)
            GlobalBestFunc = minimum(FuncVal)
            GlobalBestPosition = PositionT[:,indmin(FuncVal)]
        end

        println("BestFunctionValue: $GlobalBestFunc")
        println("BestPosition: $GlobalBestPosition")

        InertialW = InertialW*InertialDump

    end

    end
